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

  describe '#print' do

  end

  describe '#to_s' do
    let(:minefield) { Minefield.new(width: 10, height: 10, mine_count: 4) }
    subject(:printer) { described_class.new(minefield)}

    context 'minefield with no cells revealed' do
      it 'returns a string' do
        expect(printer.to_s).to be_a(String)
      end

      it 'has the correct number of rows' do
        expect(printer.to_s.lines.count).to eq(10)
      end

      it 'has the correct number of cells' do
        expect(printer.to_s.lines.first.chomp).to eq(MinefieldPrinter::STRINGS::CLOSED_CELL * 10)
      end

      it 'only displays non-revealed cells' do
        expect(printer.to_s).to match(/^(#{MinefieldPrinter::STRINGS::CLOSED_CELL}|\n)*$/)
      end
    end

    context 'minefield with some cells revealed' do
      context 'mines revealed' do
      end

      context 'hints revealed' do
      end
    end

    context 'minefield with all cells revealed' do
    end
  end
end
