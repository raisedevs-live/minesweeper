require_relative '../lib/prompt.rb'

describe Prompt do
  subject(:prompt) { described_class.new }

  describe '#welcome' do
    let(:result) { prompt.welcome }

    it 'prints the welcome message' do
      expect { result }.to output("#{Prompt::STRINGS::WELCOME}\n").to_stdout
    end

    it 'returns nil' do
      expect(result).to eq(nil)
    end
  end

  describe '#reveal_at' do
    let(:result) { prompt.reveal_at }

    context 'singular valid user input' do
      before do
        allow(prompt).to receive(:gets).and_return('3,7')
      end

      it 'prints the reveal prompt' do
        expect { result }.to output("#{Prompt::STRINGS::REVEAL_AT}\n").to_stdout
      end

      it 'returns the coordinates' do
        expect(result).to eq( [ {x: 3, y:7 } ] )
      end
    end

    context 'plural valid user input' do
      before do
        allow(prompt).to receive(:gets).and_return('3,7:2,4')
      end

      it 'prints the reveal prompt' do
        expect { result }.to output("#{Prompt::STRINGS::REVEAL_AT}\n").to_stdout
      end

      it 'returns the coordinates' do
        expect(result).to eq( [ {x: 3, y:7 }, {x: 2, y:4 } ] )
      end
    end

    context 'invalid user input' do
      before do
        allow(subject).to receive(:gets).and_return('invalid')
      end

      it 'raises a UserInputError' do
        expect { result }.to raise_error(Prompt::UserInputError)
      end
    end
  end

  describe '#lose' do
    let(:result) { prompt.lose }

    it 'prints the lose message' do
      expect { result }.to output("#{Prompt::STRINGS::LOSE}\n").to_stdout
    end

    it 'returns nil' do
      expect(result).to eq(nil)
    end
  end

  describe '#win' do
    let(:result) { prompt.win }

    it 'prints the win message' do
      expect { result }.to output("#{Prompt::STRINGS::WIN}\n").to_stdout
    end
  end

  describe '#exit' do
    let(:result) { prompt.exit }

    it 'prints the exit message' do
      expect{ result }.to output("#{Prompt::STRINGS::EXIT}\n").to_stdout
    end
  end
end
