#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.chars

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
  else
    shots << s.to_i
  end
end

shot_count = 0 # 何投目か
frame_count = 1 # 何フレーム目か
frame_point = 0 # フレームごとの点数
total_point = 0 # 合計点

shots.each_with_index do |s, i|
  shot_count += 1
  frame_point += s
  if frame_count == 10 # 10フレーム目3投目の判定と処理
    if shot_count == 1 && s == 10 # ストライクの場合
      total_point += frame_point + shots[i + 1] + shots[i + 2]
      break
    elsif frame_point == 10 # スペアの場合
      total_point += frame_point + shots[i + 1]
      break
    end
  end

  if shot_count == 1 && s == 10 # ストライクの判定と処理
    total_point += frame_point + shots[i + 1] + shots[i + 2]
    frame_count += 1
    frame_point = 0
    shot_count = 0
    next
  elsif frame_point == 10 # スペアの判定と処理
    total_point += frame_point + shots[i + 1]
    frame_count += 1
    frame_point = 0
    shot_count = 0
    next
  end

  next unless shot_count == 2 # 2投目の後に次のフレームへ

  total_point += frame_point
  frame_count += 1
  frame_point = 0
  shot_count = 0
end

puts total_point
