require_relative '../lib/minefield.rb'

describe Minefield do
  describe '.new' do
    subject(:result) { described_class.new(width: width, height: height, mine_count: mine_count) }

    context 'when initialized with valid options' do
      let(:width) { 10 }
      let(:height) { 10}
      let(:mine_count) { 4 }

      it 'returns an instance of Minefield' do
        expect(result).to be_a(Minefield)
      end

      it 'does not raise an exception' do
        expect { result }.to_not raise_error
      end
    end

    context 'when intialized with invalid options' do
      context 'invalid dimension' do
        let(:width) { 0 }
        let(:height) { 10 }
        let(:mine_count) { 4 }

        it 'raises an ArgumentError' do
          expect { result }.to raise_error(ArgumentError)
        end
      end

      context 'invalid mine count' do
        let(:width) { 5 }
        let(:height) { 5 }
        let(:mine_count) { 26 }

        it 'raises an ArgumentError' do
          expect { result }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
