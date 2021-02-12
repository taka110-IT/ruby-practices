#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def line_count(l)
  l.count("\n")
end

def word_count(w)
  w.split(/\s+|[[:blank:]]+/).size
end

options = ARGV.getopts('l')
files = ARGV
file_contents = []
total_line = 0
total_word = 0
total_size = 0

if File.pipe?(STDIN)
  ls_pipe = STDIN.read
  total_line = line_count(ls_pipe)
  total_word = word_count(ls_pipe)
  total_size = ls_pipe.size
else
  files.each_with_index do |file, index|
    File.open(file, 'r') do |f|
      content = f.read
      s = []
      s << line_count(content)
      total_line += line_count(content)
      s << word_count(content)
      total_word += word_count(content)
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
