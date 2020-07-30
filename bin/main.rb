# frozen_string_literal: true

require 'pry'

# This module is a representation of the enumerable methods!
module Enumerable
  def my_each
    return to_enum unless block_given?

    arr = to_a
    arr.length.times do |index|
      yield arr[index]
    end
    self
  end

  def my_each_with_index
    return to_enum(:each_with_index) unless block_given?

    arr = to_a
    arr.length.times do |index|
      yield arr[index], index
    end
    self
  end

  def my_select(&block)
    return to_enum(:select) unless block_given?

    output = []
    obj = to_a
    if is_a?(Hash)
      obj.my_each { |x| output.push(x) if block.call(x) }
      output.to_h
    else
      obj.to_a.my_each { |x| output.push(x) if block.call(x) }
      output.to_a
    end
  end

  def my_all?(arg = nil, &block)
    arr = to_a
    if !arg.nil?
      arr.my_each { |x| return false unless x.match(arg) } if arg.is_a?(Regexp)
      arr.my_each { |x| return false unless x.is_a?(arg) } if arg.is_a?(Class) || arg.is_a?(Module)
    elsif block_given?
      arr.my_select(&block).to_a.length == arr.length
    else
      arr.my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(&block)
    arr = to_a
    if !block_given?
      !arr.my_all? { |x| x.nil? || x == false }
    else
      arr.my_select(&block).to_a.empty? ? false : true
    end
  end

  def my_none?(&block)
    arr = to_a

    if !block_given?
      arr.my_all? { |x| x.nil? || x == false }
    else
      arr.my_select(&block).to_a.empty? ? true : false
    end
  end

  def my_count(arg = nil, &block)
    arr = to_a
    collector = []

    !arg.nil? ? collector.push(arr.my_select { |x| x == arg }).flatten.length : arr.my_select(&block).to_a.length
  end

  def my_map(&proc)
    collector = []
    arr = to_a

    return to_enum unless block_given?

    arr.length.times { |x| collector.push(proc.call(arr[x])) }
    collector
  end

  def my_inject(*args)
    arr = to_a

    if !block_given?
      memo = args[1] ? args[0] : arr[0]
      arr.drop(1).my_each { |x| memo.send(args[0], x) } unless args[1]
      arr.my_each { |x| memo.send(arg[1], x) } if args[1]
    else
      memo = args[0] || arr[0]
      arr.drop(1).my_each { |x| memo = yield memo, x } unless args[0]
      arr.my_each { |x| memo = yield memo, x } if args[0]
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(&:*)
end

arr = [52, 28, 31, 7, 28]

arr_false = [52, nil, nil, false]

obj = { "Sercan": 31, "Joe": 28, "Amita": 24 }

# list = (0..9)

# p(arr.my_select { |x| x > 100 })

hash = Hash.new
# p(%w(cat dog wombat).my_each_with_index { |item, index| hash[item] = index })

# p(arr.my_count { |x| x == 28 })

# p(arr.my_count(28))

# p(obj.my_count { |_key, value| value == 31 })

# p(arr_false.my_any?)

# p(arr.my_count)

# p(arr.my_none? { |x| x > 25 })

# p(arr.my_map { |x| x * x })

# p(obj.my_map { |_key, value| value > 25 })

# p(arr_false.my_map { |x| x != false })

# p(arr.my_inject(&:+))

# p(multiply_els([2, 4, 5]))

p %w[Marc Lac Jean].my_all?(/a/)

