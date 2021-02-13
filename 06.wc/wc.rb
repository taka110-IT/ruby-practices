#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def line_count(content)
  content.count("\n")
end

def word_count(content)
  content.split(/\s+|[[:blank:]]+/).size
end

options = ARGV.getopts('l')
files = ARGV
file_contents = []
total_line = 0
total_word = 0
total_size = 0

if File.pipe?($stdin)
  content = $stdin.read
  total_line = line_count(content)
  total_word = word_count(content)
  total_size = content.size
else
  files.each do |file|
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

if File.pipe?($stdin)
  if options['l']
    puts format('% 8d', total_line)
  else
    print format('% 8d', total_line)
    print format('% 8d', total_word)
    puts format('% 8d', total_size)
  end
elsif options['l']
  file_contents.each do |line, _word, _size, name|
    print format('% 8d', line)
    puts " #{name}"
  end
  puts format('% 8d total', total_line) if files.size >= 2
else
  file_contents.each do |line, word, size, name|
    print format('% 8<line>d% 8<word>d% 8<size>d', line: line, word: word, size: size)
    puts " #{name}"
  end
  if files.size >= 2
    print format('% 8d', total_line)
    print format('% 8d', total_word)
    puts format('% 8d total', total_size)
  end
end
