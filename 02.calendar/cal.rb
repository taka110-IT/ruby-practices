#!/usr/bin/env ruby
require 'date'
require 'optparse'

today = Date.today
yyyy = today.year
MM = today.month
puts "     #{MM}月  #{yyyy}"

year_month_options = ARGV.getopts("y:m:")  
puts "     #{year_month_options["m"]}月  #{year_month_options["y"]}"