#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'bitcoin-node'
require 'config'
require 'redis'

class Redis
  def setm(k, o)
    set(k, Marshal.dump(o))
  end
  def getm(k)
    m = get(k)
    m ? Marshal.load(m) : nil
  end
end

def scan(host, port, timeout = 30, min_last_seen = 24)
  origNode = BitcoinNode.new(host, port, timeout)
  nodes = origNode.getAddr
  return if nodes.empty?
  t = Time.now.to_i - min_last_seen * 60 * 60
  nodes.each do |node|
    if node[:services][0] == 3 && node[:services][1] == 0
      if node[:timestamp] > t
        yield node
      end
    end
  end
  origNode
end

def walk(host, port, localdb)
  scan(host, port) do |node|
    key = [node[:ipv4], node[:port]]
    entry = localdb[key] || {}
    ts = entry[:timestamp]
    nts = node[:timestamp]
    entry[:timestamp] = ts ? [ts, nts].max : nts
    localdb[key] = entry
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

def dice(a)
  a[rand(a.size)]
end

def shownodes(localdb)
  localdb.each do |k, v|
    host, port = k
    nt = v[:timestamp]
    version = v[:version]
    subversion = v[:subversion]
p [host, port, nt, version, subversion]
  end
puts
end

def subloop(localdb)
  freshnodes = getfreshnodes(localdb, rand(24))
  shownodes(freshnodes)
  host, port = dice(freshnodes.keys)
  begin
    node = walk(host, port, localdb)
    if node
      key = [host, port]
      localdb[key] = {
        :timestamp => Time.now.to_i,
        :version => node.getVersion,
        :subversion => node.getSubversion,
      }
    end
  rescue => x
p x
  end
end

def mainloop
  coinsdb = Redis.new
  coinkeys = CONFIG.keys
  coinkeys.each do |coinkey|
    coin = CONFIG[coinkey]
    coindb = coinsdb.getm("dnsseed:#{coinkey}") || {}
    coin[:seed_nodes].each do |host, port|
      key = [host, port]
      coindb[key] = { :timestamp => Time.now.to_i } unless coindb[key]
    end
    coinsdb.setm("dnsseed:#{coinkey}", coindb)
  end
  waitsec = 1
  loop do
    coinkeys.each do |coinkey|
      coin = CONFIG[coinkey]
      coindb = coinsdb.getm("dnsseed:#{coinkey}")
      subloop(coindb)
      coinsdb.setm("dnsseed:#{coinkey}", coindb)
    end
    sleep waitsec
  end
end

mainloop
