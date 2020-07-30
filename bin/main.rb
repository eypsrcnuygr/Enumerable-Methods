# frozen_string_literal: true

require 'pry'

def class_check(arg)
  if arg.is_a?(Regexp)
    my_select { |x| x.to_s.match(arg) }
  elsif arg.is_a?(Class)
    my_select { |x| x.is_a?(arg) }
  elsif arg.is_a?(Module)
    my_select { |x| x.is_a?(arg) }
  else
    my_select { |x| x == arg }
  end
end

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
      class_check(arg).to_a == arr
    elsif block_given?
      arr.my_select(&block).to_a.length == arr.length
    else
      arr.my_each { |x| return false unless x }
    end
  end

  def my_any?(arg = nil, &block)
    arr = to_a
    if !block_given?
      !arr.my_all? { |x| x.nil? || x == false } unless arg
      class_check(arg).empty? ? false : true
    else
      arr.my_select(&block).to_a.empty? ? false : true
    end
  end

  def my_none?(arg = nil, &block)
    arr = to_a

    if !block_given?
      arr.my_all? { |x| x.nil? || x == false } unless arg
      class_check(arg).empty?
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
      if args[1]
        arr.my_each { |x| memo.send(arg[1], x) }
      else
        arr.drop(1).my_each { |x| memo.send(args[0], x) }
      end
    else
      memo = args[0] || arr[0]
      if args[0]
        arr.my_each { |x| memo = yield memo, x }
      else
        arr.drop(1).my_each { |x| memo = yield memo, x }
      end
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(&:+)
end
