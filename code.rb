require 'pry'

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

  p sum
end

sum_of_intervals(ARGV)
