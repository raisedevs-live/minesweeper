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

      it 'contains the correct number of cells with mines' do
        expect(result.rows.flatten.inject(0) { |count, cell| cell.mine? ? count += 1 : count }).to eq(4)
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

  describe '#rows' do
    subject(:result) { described_class.new(width: 10, height: 15, mine_count: 5).rows }

    it 'returns an array' do
      expect(result).to be_an(Array)
    end

    it 'returns the correct number of rows' do
      expect(result.length).to eq(15)
    end

    it 'returns the correct number of columns' do
      expect(result.first.length).to eq(10)
    end

    it 'returns the correct number of Cells' do
      expect(result.flatten.count { |e| e.class == Cell }).to eq(150)
    end

    it 'only returns Cells' do
      expect(result.flatten).to all(be_a(Cell))
    end
  end

  describe '#reveal_at' do
    let(:minefield) { described_class.new(width: 10, height: 15, mine_count: 5) }
    context 'invalid coordinates passed' do
      subject(:result) { minefield.reveal_at(10, 5) }

      it 'raises an Minefield::OutOfBoundsError error' do
        expect { result }.to raise_exception(Minefield::OutOfBoundsError)
      end
    end

    context 'valid coordinates passed' do
      subject(:result) { minefield.reveal_at(3,2) }

      it 'reveals the specifed cell' do
        expect(result.revealed?).to eq(true)
      end

      it 'returns the correct cell' do
        expect(result).to eq(minefield.cell_at(3,2))
      end
    end
  end

  describe '#cell_at' do
    subject(:minefield) { described_class.new(width: 10, height: 15, mine_count: 5) }

    context 'invalid coordinates passed' do
      it 'raises an Minefield::OutOfBoundsError error' do
        expect { minefield.cell_at(10, 5) }.to raise_exception(Minefield::OutOfBoundsError)
      end
    end

    context 'valid coordinates passed' do
      let(:result) { minefield.cell_at(2,3) }

      it 'returns a cell' do
        expect(result).to be_a(Cell)
      end

      it 'returns the correct cell' do
        expect(result).to eq(minefield.instance_variable_get(:@field)[3][2])
      end
    end
  end

  describe '#mine_revealed?' do
    subject(:minefield) { described_class.new(width: 10, height: 10, mine_count: 1) }

    it 'returns false if no mine has been revealed' do
      expect(minefield.mine_revealed?).to be(false)
    end

    it 'returs true if a mine has been revealed' do
      minefield.reveal_at(0,0)
      expect(minefield.mine_revealed?).to be(true)
    end
  end
end