# frozen_string_literal: true

# Write a function that, given a string of text (possibly with punctuation and line-breaks), returns an array of the top-3 most occurring words, in descending order of the number of occurrences.
# Assumptions:
#
#     A word is a string of letters (A to Z) optionally containing one or more apostrophes (') in ASCII.
#     Apostrophes can appear at the start, middle or end of a word ('abc, abc', 'abc', ab'c are all valid)
#     Any other characters (e.g. #, \, / , . ...) are not part of a word and should be treated as whitespace.
#     Matches should be case-insensitive, and the words in the result should be lowercased.
#     Ties may be broken arbitrarily.
#     If a text contains fewer than three unique words, then either the top-2 or top-1 words should be returned, or an empty array if a text contains no words.
#
# Examples:
# 
# top_3_words("In a village of La Mancha, the name of which I have no desire to call to
# mind, there lived not long since one of those gentlemen that keep a lance
# in the lance-rack, an old buckler, a lean hack, and a greyhound for
# coursing. An olla of rather more beef than mutton, a salad on most
# nights, scraps on Saturdays, lentils on Fridays, and a pigeon or so extra
# on Sundays, made away with three-quarters of his income.")
# # => ["a", "of", "on"]
#
# top_3_words("e e e e DDD ddd DdD: ddd ddd aa aA Aa, bb cc cC e e e")
# # => ["e", "ddd", "aa"]
#
# top_3_words("  //wont won't won't")
# # => ["won't", "wont"]

# My solution
def top_3_words(text)
  split = text.downcase.tr(',.?!/', '').split
  split.delete(split[0]) if split[0] == "'" || split[0] == "'''"
  h = {}

  split.each do |item|
    if h[item]
      h[item] += 1
    else
      h[item] = 1
    end
  end

  a = h.sort_by { |_, v| v }.reverse.to_h
  a.keys.first(3)
end

# Alternative solution
def top_3_words(text)
  # text.downcase.scan(/\w+[\w']*/)
  # text.downcase.scan(/[a-z]+[a-z']*/)
  split = text.gsub(" ' ", '').tr(',.?!/', '').split
  split.each_with_object(Hash.new(0)) { |item, hash| hash[item] += 1 }
       .sort_by { |_, v| v }
       .reverse
       .to_h
       .keys
       .take(3)
end

def top_3_words(text)
  arr = text.downcase.scan(/\w(?:'|\w)*/)
  arr.uniq.max_by(3) { |w| arr.count w }
end
'============================================================================================================================'

# How many numbers III?
# --------------------

# We want to generate all the numbers of three digits where:
# 
#     the sum of their digits is equal to 10
#     their digits are in increasing order (the numbers may have two or more equal contiguous digits)
# 
# The numbers that fulfill these constraints are: [118, 127, 136, 145, 226, 235, 244, 334]. There're 8 numbers in total with 118 being the lowest and 334 being the greatest.
# Task
# 
# Implement a function which receives two arguments:
# 
#     the sum of digits (sum)
#     the number of digits (count)
# 
# This function should return three values:
# 
#     the total number of values which have count digits that add up to sum and are in increasing order
#     the lowest such value
#     the greatest such value
# 
# Note: if there're no values which satisfy these constaints, you should return an empty value (refer to the examples to see what exactly is expected).
# Examples
# 
# find_all(10, 3)  =>  [8, 118, 334]
# find_all(27, 3)  =>  [1, 999, 999]
# find_all(84, 4)  =>  []

# my solution
def find_all(n, k)
  digits = (1..9).to_a
  combinations = digits.repeated_combination(k).select { |comb| comb.inject(:+) == n }
  combinations.empty? ? [] : [combinations.size, combinations.min.join.to_i, combinations.max.join.to_i]
end

# Alternative solution
def find_all(n, k)
  arr = [*(1..9)].repeated_combination(k)
                 .select { |v| v.sum == n }
                 .map { |v| v.sort.join.to_i }
                 .uniq

  arr.empty? ? [] : [arr.size, arr.min, arr.max]
end
'================================================================================================================================='
# Recover a secret string from random triplets
#---------------------------------------------
#
#There is a secret string which is unknown to you. Given a collection of random triplets from the string, recover the original string.

# A triplet here is defined as a sequence of three letters such that each letter occurs somewhere before the next in the given string. "whi" is a triplet for the string "whatisup".
# ``
# As a simplification, you may assume that no letter occurs more than once in the secret string.
#
# You can assume nothing about the triplets given to you other than that they are valid triplets and that they contain sufficient information to deduce the original string.
# In particular, this means that the secret string will never contain letters that do not occur in one of the triplets given to you.
#
#Test cases
#secret_1 = "whatisup"
# triplets_1 = [
#   ['t','u','p'],
#   ['w','h','i'],
#   ['t','s','u'],
#   ['a','t','s'],
#   ['h','a','p'],
#   ['t','i','s'],
#   ['w','h','s']
# ]
# Test.assert_equals(recover_secret(triplets_1), secret_1)
# 
# secret_2 = "mathisfun"
# triplets_2 = [
#   ['t','s','f'],
#   ['a','s','u'],
#   ['m','a','f'],
#   ['a','i','n'],
#   ['s','u','n'],
#   ['m','f','u'],
#   ['a','t','h'],
#   ['t','h','i'],
#   ['h','i','f'],
#   ['m','h','f'],
#   ['a','u','n'],
#   ['m','a','t'],
#   ['f','u','n'],
#   ['h','s','n'],
#   ['a','i','s'],
#   ['m','s','n'],
#   ['m','s','u']
# ]
# 
# Test.assert_equals(recover_secret(triplets_2), secret_2)
# 
# Alternative solution
def recover_secret(triplets)
  r = triplets.flatten.uniq
  triplets.each do |e|
    fix(r, e[1], e[2])
    fix(r, e[0], e[1])
  end
  r.join
end

def fix(l, a, b)
  if l.index(a) > l.index(b)
    l.delete(a)
    l.insert(l.index(b), a)
  end
end
----------------------------------------------------

def recover_secret triplets
  chars = triplets.flatten.uniq
  return '' if chars.empty?

  first_chr = chars.select do |chr|
    triplets.all? do |tl|
      [0, nil].include? tl.index(chr)
    end
  end
  first_chr = first_chr.first

  new_trips = triplets.map do |tl|
    tl.first == first_chr ? tl[1..-1] : tl
  end

  first_chr + recover_secret(new_trips)
end

# Next smaller number with the same digits
# --------------------------------------------
#
# Write a function that takes a positive integer and returns the next smaller positive integer containing the same digits.

# For example:
# 
# next_smaller(21) == 12
# next_smaller(531) == 513
# next_smaller(2071) == 2017
# 
# Return -1 (for Haskell: return Nothing, for Rust: return None), when there is no smaller number that contains the same digits. Also return -1 when the next smaller number with the same digits would require the leading digit to be zero.
# 
# next_smaller(9) == -1
# next_smaller(135) == -1
# next_smaller(1027) == -1  # 0721 is out since we don't write numbers with leading zeros

# My solution (out of time limit)
# ---------------

def next_smaller(n)
  number = n.digits.permutation.uniq.map { |d| d if d[0] != 0 }.compact.map { |d| d.join.to_i }.sort.keep_if { |d| d < n }.last

  return number if number

  '-1'
end

# Alternative solution
# ---------------------
def next_smaller n
  min = n.digits.sort
  index = min.index { |x| x != 0 }
  min[0], min[index] = min[index], min[0] if min[0].zero?
  return -1 if n == min.join.to_i

  m = n - 1
  m -= 1 while m.digits.sort != n.digits.sort
end

# Sum of Intervals
# --------------------------------------
# 
# Write a function called sumIntervals/sum_intervals() that accepts an array of intervals, and returns the sum of all the interval lengths. Overlapping intervals should only be counted once.
# Intervals
# 
# Intervals are represented by a pair of integers in the form of an array. The first value of the interval will always be less than the second value. Interval example: [1, 5] is an interval from 1 to 5. The length of this interval is 4.
# Overlapping Intervals
# 
# List containing overlapping intervals:
# 
# [
#    [1,4],
#    [7, 10],
#    [3, 5]
# ]
# 
# The sum of the lengths of these intervals is 7. Since [1, 4] and [3, 5] overlap, we can treat the interval as [1, 5], which has a length of 4.
# Examples:
# 
# sumIntervals( [
#    [1,2],
#    [6, 10],
#    [11, 15]
# ] ) => 9
# 
# sumIntervals( [
#    [1,4],
#    [7, 10],
#    [3, 5]
# ] ) => 7
# 
# sumIntervals( [
#    [1,5],
#    [10, 20],
#    [1, 6],
#    [16, 19],
#    [5, 11]
# ] ) => 19
# 
# sumIntervals( [
#    [0, 20],
#    [-100000000, 10],
#    [30, 40]
# ] ) => 100000030
# 
# My solution (dont pass all tests)
# ---------------------------------

def sum_of_intervals(intervals)
  intervals = [[1, 5], [10, 20], [1, 6], [16, 19], [5, 11]].uniq.sort_by(&:last)
  overlap_intervals = []
  new_intervals = []
  sum = 0

  # intervals.each_with_index do |interval, i|
  #   i += 1

  #   intervals.drop(i).each do |int|
  #     interval.each do |d|
  #       if d.between?(int[0], int[1])
  #         overlap_intervals << interval << int
  #       end
  #     end
  #   end
  # end

  # overlap_intervals.uniq!
  # overlap_intervals.sort_by!(&:last)
  # over = overlap_intervals.first[0], overlap_intervals.last[1] if overlap_intervals.any?
  # overlap_intervals << over

  # a = intervals - overlap_intervals
  # b = overlap_intervals - intervals
  # new_intervals = a + b

  # new_intervals.compact.each do |interval|
  #   sum += (interval[1] - interval[0])
  # end

  # p sum

  new_intervals = intervals.sort_by(&:first).each_with_object([intervals.first]) do |interval, arr|
    if interval.first <= arr.last.last
      arr[-1] = arr.last.first, [arr.last.last, interval.last].max
    else
      arr << interval
    end
  end

  new_intervals.each do |interval|
    sum += (interval[1] - interval[0])
  end

  sum
end

# StackOverFlow solution
# ----------------------------

def completed_range_span(r)
  r.end - r.begin
end

def sum_of_intervals(arr)
  # convert arr to an array of ranges ordered by beginning of range
  a = arr.map { |e| e.first..e.last }.sort_by(&:begin)
  tot = 0
  loop do
    # If a contains only a single range add the span of that range to tot,
    # after which we are finished
    break (tot + completed_range_span(a.first)) if a.size == 1

    # We're not finished
    # For readability, assign first two elements of a to variables
    r0 = a[0]
    r1 = a[1]

    # If r0 and r1 do not overlap add the span of r0 to tot
    # else alter r1 to be the range formed by r0 and r1

    if r0.end < r1.begin
      tot += completed_range_span(r0)
    else
      a[1] = r0.begin..[r0.end, r1.end].max
    end

    # remove r0
    a.shift
  end
end

# Alternative solutions
# -------------------------------

def sum_of_intervals(arr)
  s, top = 0, nil

  for a, b in arr.sort do
    top = a if top.nil? || top < a
    if b > top
      s  += b - top
      top = b
    end
  end

  s
end

def sum_of_intervals(intervals)
  intervals.sort.reduce([0, -1.0 / 0]) { |(s, r), (a, b)| [s + [b, r].max - [a, r].max, [b, r].max] }[0]
end

def sum_of_intervals(intervals)
  intervals.map { |i| i.first...i.last }.map(&:to_a).inject(:|).size
end

def sum_of_intervals(intervals)
  intervals.map { |i| (i[0]...i[1]).to_a }.flatten.uniq.size
end
