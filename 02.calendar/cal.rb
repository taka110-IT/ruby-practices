#!/usr/bin/env ruby
require 'date'
require 'optparse'

year_month_options = ARGV.getopts("y:m:")

if year_month_options["m"] != nil
  MM = year_month_options["m"]
else
  MM = Date.today.month
end

if year_month_options["y"] != nil
  yyyy = year_month_options["y"]
else
  yyyy = Date.today.year
end

puts "      #{MM}月 #{yyyy}"
puts "日 月 火 水 木 金 土"
