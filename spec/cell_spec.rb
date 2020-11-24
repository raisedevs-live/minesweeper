require_relative '../lib/cell.rb'

describe Cell do
  describe '.new' do
    it 'returns an instance of Cell' do
      expect(described_class.new).to be_a(Cell)
    end

    context 'when initialized with a mine' do
      let(:cell) { Cell.new(mine: true) }

      it 'does not raise an error' do
        expect { cell }.to_not raise_error
      end

      it 'reports having a mine' do
        expect(cell.mine?).to eq(true)
      end
    end

    context 'when initialized with no mine' do
      let(:cell) { Cell.new(mine: false) }

      it 'does not raise an error' do
        expect { cell }.to_not raise_error
      end

      it 'reports not having a mine' do
        expect(cell.mine?).to eq(false)
      end
    end

    context 'when initialized with no argument' do
      let(:cell) { Cell.new() }

      it 'does not raise an error' do
        expect { cell }.to_not raise_error
      end

      it 'reports not having a mine' do
        expect(cell.mine?).to eq(false)
      end
    end

    context 'when initialized with invalid arguments' do
      context 'argument is the wrong type' do
        let(:cell) { Cell.new(mine: 25) }

        it 'raises an ArgumentError' do
          expect { cell }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe '#mine?' do
    context 'does not have a mine' do
      let(:cell) { Cell.new(mine: false) }

      it 'returns false' do
        expect(cell.mine?).to eq(false)
      end
    end

    context 'has a mine' do
      let(:cell) { Cell.new(mine: true) }

      it 'returns true' do
        expect(cell.mine?).to eq(true)
      end
    end
  end

  describe '#reveal!' do
    let(:cell) { Cell.new }

    context 'after revealiing' do
      before do
        cell.reveal!
      end

      it 'reveals the cell' do
        expect(cell.revealed?).to eq(true)
      end
    end
  end

  describe '#revealed?' do
    let(:cell) { Cell.new }

    context 'on initialize' do
      it 'is not revealed' do
        expect(cell.revealed?).to eq(false)
      end
    end

    context 'the cell has been revealed' do
      before do
        cell.reveal!
      end

      it 'is revealed' do
        expect(cell.revealed?).to eq(true)
      end
    end
  end
end
