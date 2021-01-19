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

    context 'when initialized with optional randomization arguments' do
      subject(:result) { described_class.new(width: width, height: height, mine_count: mine_count, seed: seed) }
      let(:width) { 10 }
      let(:height) { 10}
      let(:mine_count) { 4 }

      context 'the seed is none' do
        let(:seed) { :none }

        it 'does not shuffle the cells' do
          expect(result.rows.first[0..3].all?(&:mine?)).to be(true)
        end

        it 'sets the correct hint on each cell' do
          # row 0: XXXX1OOOOO
          # row 1: 23321OOOOO
          # row 2: OOOOOOOOOO (continues to row 9)

          aggregate_failures 'mines' do
            expect { result.cell_at(0,0).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(1,0).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(2,0).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(3,0).hint }.to raise_error(Cell::HintError::HasMine)
          end

          aggregate_failures 'zero hints' do
            expect(result.rows[0][5..9].all? { |cell| cell.hint == 0}).to be(true)
            expect(result.rows[1][5..9].all? { |cell| cell.hint == 0}).to be(true)
            expect(result.rows[2..9].flatten.all? { |cell| cell.hint == 0}).to be(true)
          end

          aggregate_failures 'nonzero hints' do
            expect(result.cell_at(4,0).hint).to eq(1)
            expect(result.cell_at(0,1).hint).to eq(2)
            expect(result.cell_at(1,1).hint).to eq(3)
            expect(result.cell_at(2,1).hint).to eq(3)
            expect(result.cell_at(3,1).hint).to eq(2)
            expect(result.cell_at(4,1).hint).to eq(1)
          end
        end
      end

      context 'the seed is an integer' do
        let(:seed) { 1 }

        it 'shuffles the cells the same way every time' do
          aggregate_failures do
            expect(result.cell_at(0,2).mine?).to be(true)
            expect(result.cell_at(8,5).mine?).to be(true)
            expect(result.cell_at(8,6).mine?).to be(true)
            expect(result.cell_at(0,9).mine?).to be(true)
          end
        end

        it 'sets the correct hint on each cell' do
          # 10x10 4 mines with seed of 1
          # row 0: OOOOOOOOOO
          # row 1: 11OOOOOOOO
          # row 2: X1OOOOOOOO
          # row 3: 11OOOOOOOO
          # row 4: OOOOOOO111
          # row 5: OOOOOOO2X2
          # row 6: OOOOOOO2X2
          # row 7: OOOOOOO111
          # row 8: 11OOOOOOOO
          # row 9: X1OOOOOOOO

          aggregate_failures 'mines' do
            expect { result.cell_at(0,2).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(8,5).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(8,6).hint }.to raise_error(Cell::HintError::HasMine)
            expect { result.cell_at(0,9).hint }.to raise_error(Cell::HintError::HasMine)
          end

          # aggregate_failures 'zero hints' do
          #   # TODO: all other cells should have hint zero
          #   expect(result.rows[0][0..9].all? { |cell| cell.hint == 0}).to be(true)
          # end

          aggregate_failures 'nonzero hints' do
            expect(result.cell_at(0,1).hint).to eq(1)
            expect(result.cell_at(1,1).hint).to eq(1)

            expect(result.cell_at(1,2).hint).to eq(1)

            expect(result.cell_at(0,3).hint).to eq(1)
            expect(result.cell_at(1,3).hint).to eq(1)

            expect(result.cell_at(7,4).hint).to eq(1)
            expect(result.cell_at(8,4).hint).to eq(1)
            expect(result.cell_at(9,4).hint).to eq(1)

            expect(result.cell_at(7,5).hint).to eq(2)
            expect(result.cell_at(9,5).hint).to eq(2)

            expect(result.cell_at(7,6).hint).to eq(2)
            expect(result.cell_at(9,6).hint).to eq(2)

            expect(result.cell_at(7,7).hint).to eq(1)
            expect(result.cell_at(8,7).hint).to eq(1)
            expect(result.cell_at(9,7).hint).to eq(1)

            expect(result.cell_at(0,8).hint).to eq(1)
            expect(result.cell_at(1,8).hint).to eq(1)

            expect(result.cell_at(1,9).hint).to eq(1)
          end
        end
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

      context 'invalid seed' do
        subject(:result) { described_class.new(width: width, height: height, mine_count: mine_count, seed: seed) }
        let(:width) { 5 }
        let(:height) { 5 }
        let(:mine_count) { 1 }
        let(:seed) { :invalid }

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
    let(:minefield) { described_class.new(width: 10, height: 10, mine_count: 4, seed: 1) }
    # 10x10 4 mines with seed of 1
    # row 0: OOOOOOOOOO
    # row 1: 11OOOOOOOO
    # row 2: X1OOOOOOOO
    # row 3: 11OOOOOOOO
    # row 4: OOOOOOO111
    # row 5: OOOOOOO2X2
    # row 6: OOOOOOO2X2
    # row 7: OOOOOOO111
    # row 8: 11OOOOOOOO
    # row 9: X1OOOOOOOO

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

    context 'sweeping' do
      let(:revealed_count) do
        minefield.rows.flatten.reduce(0) do |revealed_count, cell|
          cell.revealed? ? revealed_count += 1 : revealed_count
        end
      end

      context 'no sweeping needed' do
        before do
          minefield.reveal_at(1,3)
        end

        it 'reveals exactly one cell' do
          expect(revealed_count).to eq(1)
        end
      end

      context 'sweeping required' do
        before do
          minefield.reveal_at(0,0)
        end

        it 'reveals the correct number of cells' do
          expect(revealed_count).to eq(94)
        end

        it 'does not sweep past hints' do
          aggregate_failures do
            expect(minefield.cell_at(9,5).revealed?).to eq(false)
            expect(minefield.cell_at(9,6).revealed?).to eq(false)
          end
        end
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
    subject(:minefield) { described_class.new(width: 10, height: 10, mine_count: 1, seed: :none) }

    it 'returns false if no mine has been revealed' do
      expect(minefield.mine_revealed?).to be(false)
    end

    it 'returs true if a mine has been revealed' do
      minefield.reveal_at(0,0)
      expect(minefield.mine_revealed?).to be(true)
    end
  end

  describe '#cleared?' do
    subject(:minefield) { described_class.new(width: 10, height: 10, mine_count: 1, seed: :none) }

    context 'all empty cells revealed' do
      it 'returns true' do
        cells = minefield.rows.flatten
        cells.shift
        cells.map(&:reveal!)
        expect(minefield.cleared?).to be(true)
      end
    end

    context 'some empty cells not revealed' do
      it 'returns false' do
        expect(minefield.cleared?).to be(false)
      end
    end
  end
end
