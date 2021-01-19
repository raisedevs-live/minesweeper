require_relative '../lib/minefield_printer.rb'

describe MinefieldPrinter do
  describe '.new' do
    subject(:printer) { described_class.new(minefield) }

    context 'valid arguments' do
      let(:minefield) { Minefield.new(width: 10, height: 10, mine_count: 4) }

      it 'returns an instance of MinefieldPrinter' do
        expect(printer).to be_a(MinefieldPrinter)
      end
    end

    context 'invalid arguments' do
      let(:minefield) { "minefield" }

      it 'raises an ArgumentError' do
        expect { printer }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#to_s' do
    let(:minefield) { Minefield.new(width: 10, height: 10, mine_count: 4, seed: :none) }
    subject(:printer) { described_class.new(minefield)}

    it 'returns a string' do
      expect(printer.to_s).to be_a(String)
    end

    it 'has the correct number of rows' do
      expect(printer.to_s.lines.count).to eq(10)
    end

    it 'has the correct number of cells' do
      expect(printer.to_s.lines.first.chomp).to eq(MinefieldPrinter::STRINGS::CLOSED * 10)
    end

    context 'minefield with no cells revealed' do
      it 'only displays non-revealed cells' do
        expect(printer.to_s).to match(/^(#{MinefieldPrinter::STRINGS::CLOSED}|\n)*$/)
      end
    end

    context 'minefield with some cells revealed' do
      context 'one cell with a mine is revealed' do
        before do
          minefield.reveal_at(0,0)
        end

        it 'displays a mine at the correct location' do
          cell = printer.to_s.lines[0].split('').first
          expect(cell).to include(MinefieldPrinter::STRINGS::MINE)
        end
      end

      context 'one empty cell is revealed' do
        before do
          minefield.reveal_at(0,2)
        end

        it 'displays an empty cell at the correct location' do
          cell = printer.to_s.lines[2].split('').first
          expect(cell).to eq(MinefieldPrinter::STRINGS::EMPTY)
        end
      end

      context 'hints revealed' do
        # row 0: XXXX1OOOOO
        # row 1: 23321OOOOO
        # row 2: OOOOOOOOOO (continues to row 9)

        let(:result) { printer.to_s }
        let(:hints)  { MinefieldPrinter::STRINGS::HINTS }
        let(:closed) { MinefieldPrinter::STRINGS::CLOSED }

        before do
          minefield.reveal_at(4,0)
          minefield.reveal_at(0,1)
          minefield.reveal_at(1,1)
          minefield.reveal_at(2,1)
          minefield.reveal_at(3,1)
          minefield.reveal_at(4,1)
        end

        it 'displays the correct hints on the first line' do
          line = "#{closed * 4}#{hints[1]}#{closed * 5}\n"
          expect(result.lines.first).to eq(line)
        end

        it 'displays the correct hints on the second line' do
          line = "#{hints[2]}#{hints[3]}#{hints[3]}#{hints[2]}#{hints[1]}#{closed * 5}\n"
          expect(result.lines[1]).to eq(line)
        end
      end
    end

    context 'minefield with all cells revealed' do
    end
  end
end
