#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'bitcoin-node'

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
    entry[:timestamp] = node[:timestamp]
    localdb[key] = entry
  end
end

def getfreshnodes(localdb, min_last_seen = 1)
  t = Time.now.to_i - min_last_seen * 60 * 60
  localdb.select do |k, v|
    nt = v[:timestamp]
    nt > t
  end
end

def mainloop(host, port, waitsec)
  localdb = {}
  loop do
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
    freshnodes = getfreshnodes(localdb)
    freshnodes.each do |k, v|
      host, port = k
      nt = v[:timestamp]
      version = v[:version]
      subversion = v[:subversion]
p [host, port, nt, version, subversion]
    end
    keys = freshnodes.keys
    host, port = keys[rand(keys.size)]
p [:next, host, port]
puts
    sleep waitsec
  end
end

mainloop('127.0.0.1', 9301, 3)
