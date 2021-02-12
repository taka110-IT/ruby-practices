#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l')
files = ARGV
file_contents = []
total_line = 0
total_word = 0
total_size = 0

if File.pipe?(STDIN)
  ls_pipe = STDIN.read
  total_line = ls_pipe.count("\n")
  total_word = ls_pipe.split(/\s+|[[:blank:]]+/).size
  total_size = ls_pipe.size
else
  files.each_with_index do |file, index|
    File.open(file, 'r') do |f|
      content = f.read
      s = []
      s << content.count("\n")
      total_line += content.count("\n")
      s << content.split(/\s+|[[:blank:]]+/).size
      total_word += content.split(/\s+|[[:blank:]]+/).size
      s << File.stat(f).size
      total_size += File.stat(f).size
      s << f.path
      file_contents << s
    end
  end
end

if File.pipe?(STDIN)
  puts options['l'] ? format("% 8d", total_line) : format("% 8d% 8d% 8d", total_line, total_word, total_size)
elsif options['l']
  file_contents.each do |line, word, size, name|
    print format("% 8d", line)
    puts (" #{name}")
  end
  puts format("% 8d total", total_line) if files.size >= 2
else
  file_contents.each do |line, word, size, name|
    print format("% 8d% 8d% 8d", line, word, size)
    puts (" #{name}")
  end
  puts format("% 8d% 8d% 8d total", total_line, total_word, total_size) if files.size >= 2
end
