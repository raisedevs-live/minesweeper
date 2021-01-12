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

    context 'after revealing' do
      let!(:result) { cell.reveal! }

      it 'reveals the cell' do
        expect(cell.revealed?).to eq(true)
      end

      it 'returns self' do
        expect(result).to eq(cell)
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

  describe '#inspect' do
    let(:cell) { Cell.new(mine: contains_mine) }
    subject(:result) { cell.inspect }
    let(:contains_mine) { false }

    it 'returns a string' do
      expect(result).to be_a(String)
    end

    context 'cell contains a mine' do
      let(:contains_mine) { true }

      it 'reports the cell contains a mine' do
        expect(result).to include('mine: true')
      end
    end

    context 'cell does not contain a mine' do
      let(:contains_mine) { false }

      it 'reports the cell does not contain a mine' do
        expect(result).to include('mine: false')
      end
    end

    context 'cell is revealed' do
      before do
        cell.reveal!
      end

      it 'reports the cell is revealed' do
        expect(result).to include('revealed: true')
      end
    end

    context 'cell is not revealed' do
      it 'reports the cell is not revealed' do
        expect(result).to include('revealed: false')
      end
    end
  end

  describe '#hint=' do
    let(:cell) { Cell.new(mine: mine) }

    context 'empty cell' do
      let(:mine) { false }

      context 'invalid argument' do
        context 'incorrect type' do
          it 'raises an ArgumentError' do
            expect { cell.hint = 'a' }.to raise_error(ArgumentError)
          end
        end

        context 'below the minimum' do
          it 'raises an ArgumentError' do
            expect { cell.hint = -1 }.to raise_error(ArgumentError)
          end
        end

        context 'above the maximum' do
          it 'raises an ArgumentError' do
            expect { cell.hint = 9 }.to raise_error(ArgumentError)
          end
        end
      end

      context 'valid argument' do
        it 'sets the hint value' do
          cell.hint = 4
          expect(cell.hint).to eq(4)
        end

        it 'sets the max hint value' do
          cell.hint = 8
          expect(cell.hint).to eq(8)
        end

        it 'sets the min hint value' do
          cell.hint = 0
          expect(cell.hint).to eq(0)
        end
      end
    end

    context 'cell with mine' do
      let(:mine) { true }

      it 'raises HintError::CannotSet' do
        expect { cell.hint = 4 }.to raise_error(Cell::HintError::CannotSet)
      end
    end
  end

  describe '#hint' do
    let(:cell) { Cell.new(mine: mine) }

    context 'empty cell' do
      let(:mine) { false }

      context 'hint is not set' do
        it 'raises an HintError::Unknown error' do
          expect { cell.hint }.to raise_error(Cell::HintError::Unknown)
        end
      end

      context 'hint is set' do
        before do
          cell.hint = 4
        end

        it 'returns the hint' do
          expect(cell.hint).to eq(4)
        end
      end
    end

    context 'cell with mine' do
      let(:mine) { true }

      it 'raises a HintErorr::HasMine' do
        expect { cell.hint }.to raise_error(Cell::HintError::HasMine)
      end
    end
  end
end
