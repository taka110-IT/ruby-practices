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
file_contents_separately = []
total_line = 0
total_word = 0
total_size = 0

if File.pipe?($stdin)
  content = $stdin.read
  file_contents_separately << line_count(content)
  file_contents_separately << word_count(content)
  file_contents_separately << content.size
  file_contents_separately << nil
  file_contents << file_contents_separately
else
  files.each do |file|
    File.open(file, 'r') do |f|
      content = f.read
      file_contents_separately << line_count(content)
      total_line += line_count(content)
      file_contents_separately << word_count(content)
      total_word += word_count(content)
      file_contents_separately << File.stat(f).size
      total_size += File.stat(f).size
      file_contents_separately << f.path
      file_contents << file_contents_separately.dup
      file_contents_separately.clear
    end
  end
end

if options['l']
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
