#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'config'
require 'redis'

class Redis
  def getm(k)
    m = get(k)
    m ? Marshal.load(m) : nil
  end
end

if AMAZON[:access_key]
  require 'route53'

  def amazonupdate(coinkey, hosts)
    access_key = AMAZON[:access_key]
    secret_key = AMAZON[:secret_key]
    name = AMAZON[:name]
    target = AMAZON[:coins][coinkey]
    return unless target
    route53 = Route53::Connection.new(access_key, secret_key)
    zones = route53.get_zones
    zone = zones.find do |zone|
      zone.name == name
    end
    records = zone.get_records
    record = records.find do |record|
      record.name == "#{target}.#{name}" && record.type == 'A'
    end
    return unless record
p [:update, hosts]
    #record.update(nil, nil, nil, hosts)
  end
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
  coin = CONFIG[coinkey]
  dport = coin[:port]
  coindb = coinsdb.getm("dnsseed:#{coinkey}")
  next unless coindb
  puts
  puts coinkey
  hosts = getfreshnodes(coindb, 24).select do |key, coin|
    host, port = key
    next if host == '127.0.0.1'
    next if port != dport
    next unless coin[:version]
    next if coin[:version] < 70002
    subv = ('1' + coin[:subversion].split(':')[1].chop.split('.').join).to_i
    next if subv < 10861
    puts ipv4tohex(host)
    true
  end
  if AMAZON[:access_key]
    amazonupdate(coinkey, hosts.keys.map{|host,port| host})
  end
end
