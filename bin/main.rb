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
    if !arg.nil? && !block_given?
      class_check(arg).to_a == arr
    elsif block_given?
      arr.my_select(&block).to_a.length == arr.length
    elsif arr.my_select { |x| x == false || x.nil? }.empty?
      true
    else
      false
    end
  end

  def my_any?(arg = nil, &block)
    arr = to_a
    if !arg.nil? && !block_given?
      !class_check(arg).empty?
    elsif block_given?
      !arr.my_select(&block).to_a.empty?
    elsif arr.my_select { |x| x == false || x.nil? }.empty?
      true
    else
      false
    end
  end

  def my_none?(arg = nil, &block)
    arr = to_a

    if !arg.nil? && !block_given?
      class_check(arg).empty?
    elsif block_given?
      arr.my_select(&block).to_a.empty?
    elsif arr.my_select { |x| x == false || x.nil? }.empty?
      false
    else
      true
    end
  end

  def my_count(arg = nil, &block)
    arr = to_a
    collector = []

    !arg.nil? ? collector.push(arr.my_select { |x| x == arg }).flatten.length : arr.my_select(&block).to_a.length
  end

  def my_map(proc = nil)
    collector = []
    arr = to_a

    if proc
      arr.length.times { |x| collector.push(proc.call(arr[x])) }
    elsif block_given?
      arr.length.times { |x| collector.push(yield(x)) }
    else
      return to_enum
    end
    collector
  end

  def my_inject(*args)
    arr = to_a
    arg = args[0].is_a?(Numeric) ? args[0] : arr[0]
    inject_symbol = args.my_select { |x| x.class == Symbol }
    offset = arg == arr[0] ? 1 : 0
    if inject_symbol.empty?
      0.upto(arr.length - (1 + offset)) { |x| arg = yield(arg, arr[x + offset]) }
    else
      0.upto(arr.length - (1 + offset)) { |x| arg = arg.send(inject_symbol[0], arr[x + offset]) }
    end
    arg
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end


array = [5, 8, 15, 25, 7]
my_proc = proc {|num| num < 10 }
p array.my_map(my_proc) {|num| num < 10 } 
p array.my_map(my_proc)

p array.my_map(my_proc) {|num| num < 10 } == array.my_map(&my_proc)