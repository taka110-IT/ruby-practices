#!/usr/bin/env ruby
require 'date'
require 'optparse'

year_month_options = ARGV.getopts("y:m:")

#オプションの有無を判定し、無ければ今日の年月を代入する
if year_month_options["m"] != nil
  month = year_month_options["m"].to_i
else
  month = Date.today.month
end

if year_month_options["y"] != nil
  year = year_month_options["y"].to_i
else
  year = Date.today.year
end

puts "      #{month}月 #{year}"
puts " 日 月 火 水 木 金 土"

last_day_of_month = Date.new(year, month ,-1) #月の最終日を取得

(1..last_day_of_month.day).each do |x| #1日から月の最終日まで繰り返し処理
  if x == 1 #1日がどの曜日か判定し、インデント調整する
    Date.new(year, month, x).wday.times do
      print "   "
    end
  end
  if Date.new(year, month, x).wday == 6
    print " " if x < 10 #1〜9日の時に10の位にスペースを追加
    puts " #{x}"
  else
    print " " if x < 10 #1〜9日の時に10の位にスペースを追加
    print " #{x}"
  end
end
puts ""
