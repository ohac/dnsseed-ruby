#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'bitcoin-node'
#require 'config'
#require 'global'

host = '127.0.0.1'

port = 9301
timeout = 30
min_last_seen = 1 * 24 * 60 * 60

origNode = BitcoinNode.new(host, port, timeout)

nodes = origNode.getAddr
begin
  if !nodes.empty?
    #start_db_transaction
    #add_node_to_dns(host, port, origNode.getVersion)
    t = Time.now.to_i - min_last_seen
    nodes.each do |node|
      if node[:services][0] == 3 && node[:services][1] == 0
        if node[:timestamp] > t
p [Time.at(node[:timestamp]), node[:ipv4], node[:port]]
          #add_untested_node(node[:ipv4], node[:port])
        end
      end
    end
    #commit_db_transaction
  else
    #start_db_transaction
    #remove_node(host, port)
    #commit_db_transaction
  end
rescue
  #start_db_transaction
  #remove_node(host, port)
  #commit_db_transaction
end
