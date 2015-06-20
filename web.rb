#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'config'
require 'redis'
require 'sinatra'
require 'haml'

class Redis
  def getm(k)
    m = get(k)
    m ? Marshal.load(m) : nil
  end
end

def getfreshnodes(localdb, min_last_seen = 1)
  max = localdb.map{|k, v| v[:timestamp]}.max
  return [] unless max
  t = max - min_last_seen * 60 * 60
  localdb.select do |k, v|
    nt = v[:timestamp]
    nt > t
  end
end

def guessheight(localdb)
  cs = getfreshnodes(localdb).map{|k, v| v[:height]}.compact
  mid = cs[cs.size / 2]
  cs.select{|c|c < mid + 50}.max
end

helpers do
  def ipv4tohex(ipv4)
    "0x%s" % [ipv4.split('.').map{|x|'%02x' % x.to_i}.reverse.join]
  end
end

def getallfreshnodes
  coinsdb = Redis.new
  coinkeys = CONFIG.keys
  coins = {}
  coinkeys.each do |coinkey|
    coinconf = CONFIG[coinkey]
    dport = coinconf[:port]
    coindb = coinsdb.getm("dnsseed:#{coinkey}")
    next unless coindb
    hosts = {}
    getfreshnodes(coindb, 24).each do |key, coin|
      host, port = key
      next if host == '127.0.0.1'
      next if port != dport
      next unless coin[:version]
p [coinkey, coin[:version], coinconf[:min_version]]
      next if coin[:version] < coinconf[:min_version]
      subv = '1' + coin[:subversion].split(':')[1].chop.split('.').join
      subv = (subv + '000')[0, 5].to_i
      subvconf = 10000 + (coinconf[:subversion] || 860)
      next if subv < subvconf
      hosts[key] = coin
    end
    coins[coinkey] = {:hosts => hosts, :height => guessheight(coindb)}
  end
  coins
end

get '/' do
  coins = getallfreshnodes
  haml :index, :locals => {:coins => coins}
end
