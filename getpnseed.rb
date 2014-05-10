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
  getfreshnodes(coindb, 2).each do |key, coin|
    host, port = key
    next if host == '127.0.0.1'
    next if port != dport
    next unless coin[:version]
    next if coin[:version] < 70002
    subv = ('1' + coin[:subversion].split(':')[1].chop.split('.').join).to_i
    next if subv < 10861
    puts ipv4tohex(host)
  end
end
