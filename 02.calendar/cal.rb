#!/usr/bin/env ruby
require 'date'
require 'optparse'

year_month_options = ARGV.getopts("y:m:")

#オプションの有無を判定し、無ければ今日の年月を代入する
month = year_month_options["m"].to_i
month = Date.today.month if month == 0

year = year_month_options["y"].to_i
year = Date.today.year if year == 0

puts "      #{month}月 #{year}"
puts " 日 月 火 水 木 金 土"

last_day_of_month = Date.new(year, month ,-1) #月の最終日を取得

(1..last_day_of_month.day).each do |x| #1日から月の最終日まで繰り返し処理
  if x == 1 #1日がどの曜日か判定し、インデント調整する
    print "   " * Date.new(year, month, x).wday
  end
  if Date.new(year, month, x).wday == 6
    puts sprintf("% 3d", x)
  else
    print sprintf("% 3d", x)
  end
end
puts ""
