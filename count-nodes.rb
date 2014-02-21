#!/usr/bin/ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'config'
require 'global'

connect_to_db
result = query_version_count
puts "Nodes viable for DNS (including low version)"
result.each do |row|
	puts "#{row[1]}: #{row[0]}"
end
result = query_dns_total
puts "In DNS: #{result}"
result = query_total
puts "Total: #{result}"
