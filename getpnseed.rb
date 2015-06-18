#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'config'
require 'redis'
require 'aws-sdk'

class Redis
  def getm(k)
    m = get(k)
    m ? Marshal.load(m) : nil
  end
end


def update_record(domain, host, records, region = 'us-east-1')
  r53 = Aws::Route53::Client.new(region: region)
  zone = r53.list_hosted_zones.hosted_zones.find{|z|z.name == domain}
  r53.change_resource_record_sets(
    hosted_zone_id: zone.id,
    change_batch: {
      changes: [
        {
          action: 'UPSERT',
          resource_record_set: {
            name: "#{host}.#{domain}",
            type: 'A',
            ttl: 300,
            resource_records: records.map{|r| {value: r}}
          }
        }
      ]
    }
  )
end

def amazonupdate(coinkey, hosts)
  target = AMAZON[:coins][coinkey]
  return unless target
  update_record(AMAZON[:name], target, hosts)
end

def getfreshnodes(localdb, min_last_seen = 1)
  max = localdb.map{|k, v| v[:timestamp]}.max
  t = max - min_last_seen * 60 * 60
  localdb.select do |k, v|
    nt = v[:timestamp]
    nt > t
  end
end

def ipv4tohex(ipv4)
  "0x%s," % [ipv4.split('.').map{|x|'%02x' % x.to_i}.reverse.join]
end

coinsdb = Redis.new
coinkeys = CONFIG.keys
coinkeys.each do |coinkey|
  coinconf = CONFIG[coinkey]
  dport = coinconf[:port]
  coindb = coinsdb.getm("dnsseed:#{coinkey}")
  next unless coindb
  puts
  puts coinkey
  hosts = getfreshnodes(coindb, 24).select do |key, coin|
    host, port = key
    next if host == '127.0.0.1'
    next if port != dport
    next unless coin[:version]
    next if coin[:version] < 60007 # TODO
    subv = '1' + coin[:subversion].split(':')[1].chop.split('.').join
    subv = (subv + '000')[0, 5].to_i
    subvconf = 10000 + (coinconf[:subversion] || 860)
    next if subv < subvconf
    puts true ? ipv4tohex(host) : host
    true
  end
  amazonupdate(coinkey, hosts.keys.map{|host,port| host}.shuffle[0, 100])
end
