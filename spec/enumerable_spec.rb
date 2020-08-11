require_relative '../bin/main.rb'

describe Enumerable do
  let(:array) { [1, 3, 5, 7, 9, 8, 10] }
  context '#my_each' do
    it 'returns an enumerator when no block_given' do
      expect(array.my_each).to be_instance_of(Enumerator)
    end
    it 'returns the elements of the array' do
      checker = array.my_each { |x| x }
      expect(checker).to eql?(array)
    end
  end
end
