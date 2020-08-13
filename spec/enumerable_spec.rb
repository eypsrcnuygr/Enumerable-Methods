require_relative '../bin/main.rb'

describe Enumerable do
  let(:array) { [1, 3, 5, 7, 9, 8, 10] }
  let(:array_polly) { [1, 1, 5, 5, 5, 8, 8] }
  let(:array_with_false) { [false, 5, 7, 'string', true] }
  let(:falsey_array) { [false, nil, false, nil] }
  let(:example_proc) { proc {|n| n % 2 == 0 }} 

  describe '#my_each' do
    it 'returns an enumerator when no block_given' do
      expect(array.my_each).to be_instance_of(Enumerator)
    end
    it 'returns the elements of the array' do
      checker = array.my_each { |x| x }
      expect(checker).to eq(array)
    end
  end
  describe '#my_each_with_index' do
    it 'returns an enumerator when no block_given' do
      expect(array.my_each_with_index).to be_instance_of(Enumerator)
    end
    it 'returns the sum of array ' do
      sum = 0
      array.my_each_with_index { |item| sum += item }
      expect(sum).to eql(43)
    end
  end
  describe '#my_select' do
    it 'returns numbers > 5' do
      expect(array.my_select { |x| x > 5 }).to eql([7, 9, 8, 10])
    end
    it 'returns an empty array when the case is not satisfied' do
      expect(array.my_select { |x| x > 15 }).to eql([])
    end
  end
  describe '#my_all?' do
    it 'returns true if all items are true' do
      expect(array.my_all? { |el| el > 0 }).to eq(true)
    end
    it 'returns false if all items are not true' do
      expect(array_with_false.my_all?).not_to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true if one element is true' do
      checker = array.my_any? { |item| item > 5 }
      expect(checker).to eql(true)
    end
    it 'returns false if all elements are falsey' do
      expect(falsey_array.my_any?).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true if all elements return false' do
      checker = array.my_none? { |item| item > 15 }
      expect(checker).to eql(true)
    end
    it 'returns false if at least one element return true' do
      checker = array.my_none? { |item| item > 5 }
      expect(checker).to eql(false)
    end
  end

  describe '#my_count' do
    context 'when there is parameter' do
      it 'returns the length of the array' do
        expect(array.my_count).to eql(7)
      end
    end
    context 'when there is one parameter' do
      it 'returns how many times do the parameter appears' do
        expect(array_polly.my_count(5)).to eql(3)
      end
    end
  end

  describe '#my_map' do

    it 'returns a new array with block or proc called' do
      checker = array.my_map { |x| x * 2 }
      expect(checker).to eql [2, 6, 10, 14, 18, 16, 20]
    end
    it 'returns enumerator when no block given' do
      expect(array.my_map).to be_and Enumerator
    end
  end

  describe '#my_inject' do
    it 'return one element that is the result for the process' do
      checker = array.my_inject(5) { |x, y| x + y }
      expect(checker).to eql(48)
    end
    
  end
end
