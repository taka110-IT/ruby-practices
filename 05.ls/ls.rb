#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def file_mode(file)
  permission = File.stat(file).mode.to_s(8).slice(-3, 3).chars
  permission_list = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }
  permission.map! do |x|
    permission_list[x]
  end
  permission.insert(0, file_type(file)).join
end

def file_type(file)
  type = File.stat(file).ftype
  type_list = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'f',
    'link' => 'l',
    'socket' => 's',
    'unknown' => '?'
  }
  type_list[type]
end

def file_time(file)
  t = File.stat(file).mtime
  half_year = 60 * 60 * 24 * 180
  if t <= Time.now + half_year && t >= Time.now - half_year
    t.strftime('%_m %_d %H:%M')
  else
    t.strftime('%_m %_d  %Y')
  end
end

options = ARGV.getopts('a', 'l', 'r')

files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files.sort!

files.reverse! if options['r']

if options['l']
  file_status = []
  total_blocks = 0
  files.each do |file|
    s = []
    s << file_mode(file)
    s << File.stat(file).nlink
    s << Etc.getpwuid(File.stat(file).uid).name
    s << Etc.getgrgid(File.stat(file).gid).name
    s << File.stat(file).size
    s << file_time(file)
    s << file
    total_blocks += File.stat(file).blocks
    file_status << s.join(' ')
  end
  files = file_status
end

column = files.size / 3

files_turning = files.dup
files_display = []
if files.size > 3
  case files.size % 3
  when 1
    files_display << files_turning.slice!(0, column + 1)
    files_turning.each_slice(column) { |file| files_display << file }
    files_display[1] << nil
    files_display[2] << nil
  when 2
    files.each_slice(column + 1) { |file| files_display << file }
    files_display[2] << nil
  else
    files.each_slice(column) { |file| files_display << file }
  end

  files_display = files_display.transpose
  files_display[1].compact!
  files_display[2].compact! if files_display.size > 5
end

if files.size > 3 && !options['l']
  files_display.each do |line|
    line.each do |file|
      print format('%-18s', file)
    end
    puts ''
  end
else
  puts "total #{total_blocks}"
  puts files
end
