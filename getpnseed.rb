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

coinsdb = Redis.new
coinkeys = CONFIG.keys
coinkeys.each do |coinkey|
  coin = CONFIG[coinkey]
  coindb = coinsdb.getm("dnsseed:#{coinkey}")
  next unless coindb
  getfreshnodes(coindb, 2).each do |key, coin|
    host, port = key
p [key, coin]
  end
end
