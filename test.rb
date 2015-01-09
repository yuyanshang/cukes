#!/usr/bin/env ruby

require 'net/http'

#servers = ["http://wmsdev1app4t.elasticbeanstalk.com/rest/wms/",
#          "http://wmsdev1app3n.elasticbeanstalk.com/wms/",
#           "http://wmsdev1app3n.elasticbeanstalk.com/wmscassdb/"]

#servers = ["http://wmsdev1app4t.elasticbeanstalk.com/rest/wms/"]
#servers = ["http://wmsdev1app3n.elasticbeanstalk.com/wms/"]
servers = ["http://wmsdev1app3n.elasticbeanstalk.com/wmscassdb/"]

# 10/1/2014: HTTP post for data insert


elapsed_time = []

# read all orders
orders = File.readlines("wmstable-v1.csv", "\r").map{|line| line.split(',')[0]}

# drop the first one which is the header
orders = orders.drop(1)

# use this to control the number of API calls
number_of_orders = 100
#number_of_orders = orders.size

servers.each do |server|
  start_time = Time.now
  orders.each_with_index do |order, index|
    break if index >= number_of_orders 
    uri = URI(server + order)
    puts "#{index} => #{uri}" 
    puts Net::HTTP.get(uri)
  end
  elapsed_time << (Time.now - start_time) 
end

puts "\nRESULTS:"
puts "Get #{number_of_orders} orders"
servers.each_with_index do |server, index|
  puts server + " => #{elapsed_time[index]} seconds"
end
