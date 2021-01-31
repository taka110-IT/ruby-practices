#!/usr/bin/env ruby
require 'optparse'
require 'etc'

def file_mode(file)
  permission = File.stat(file).mode.to_s(8).slice(-3, 3).chars
  permission.map! {|x|
    case x
    when '7' then 'rwx'
    when '6' then 'rw-'
    when '5' then 'r-x'
    when '4' then 'r--'
    when '3' then '-wx'
    when '2' then '-w-'
    when '1' then '--x'
    when '0' then '---'
    end
  }
  permission.insert(0, file_type(file)).join
end

def file_type(file)
  case File.stat(file).ftype
  when 'file' then '-'
  when 'directory' then 'd'
  when 'characterSpecial' then 'c'
  when 'blockSpecial' then 'b'
  when 'fifo' then 'f'
  when 'link' then 'l'
  when 'socket' then 's'
  when 'unknown' then '?'
  end
end

def file_time(file)
  t = File.stat(file).mtime
  if t <= Time.now + (60 * 60 * 24 * 180) && t >= Time.now - (60 * 60 * 24 * 180)
    t.strftime("%_m %_d %H:%M")
  else
    t.strftime("%_m %_d  %Y")
  end
end

options = ARGV.getopts('a', 'l', 'r')

options["a"] ? files = Dir.glob("*", File::FNM_DOTMATCH).sort : files = Dir.glob("*").sort

files.reverse! if options["r"]

if options["l"]
  file_status = []
  s = []
  total_blocks = 0
    files.each do |file|
      s << file_mode(file)
      s << File.stat(file).nlink
      s << Etc.getpwuid(File.stat(file).uid).name
      s << Etc.getgrgid(File.stat(file).gid).name
      s << File.stat(file).size
      s << file_time(file)
      s << file
      total_blocks += File.stat(file).blocks
      file_status << s.join(' ')
      s.clear
    end
  files = file_status
end

column = files.size / 3

files_turning = files.dup
files_display = []
if files.size > 3
  if files.size % 3 == 1
    files_display << files_turning.slice!(0, column + 1)
    files_turning.each_slice(column) {|file|
      files_display << file
    }
    files_display[1] << nil
    files_display[2] << nil
  elsif files.size % 3 == 2
    files.each_slice(column + 1) {|file|
      files_display << file
    }
    files_display[2] << nil
  else
    files.each_slice(column) {|file|
      files_display << file
    }
  end

  files_display = files_display.transpose
  files_display[1].compact!
  files_display[2].compact! if files_display.size > 5
end

if files.size > 3 && !options["l"]
  files_display.each do |line|
    line.each do |file|
      print sprintf("%-18s", file)
    end
    puts ""
  end
else
  puts files
end
