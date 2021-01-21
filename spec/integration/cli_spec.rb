require 'spec_helper'
require 'open3'
require './lib/minefield_printer'

RSpec.describe "Command Line Interface" do
  def run_minesweeper(stdin_data: "")
    Open3.capture3('SEED=none bundle exec ruby ./bin/minesweeper', stdin_data: stdin_data)
  end

  it 'if the input stream is closed before the game is finished it prints goodbye and exits with status code zero' do
    o, e, s = run_minesweeper
    aggregate_failures do
      expect(o.end_with?("Goodbye\n")).to be(true)
      expect(s).to have_attributes(success?: true)
    end
  end

  it 'prints out the minesweeper grid' do
    o, e, s = run_minesweeper
    expect(o).to include("⬜️⬜️⬜️⬜️⬜️⬜️⬜️⬜️⬜️⬜️\n"*10)
  end

  context 'with one mine in the top left cell' do
    context 'the user reveals a mine' do
      it 'tells the player they lost' do
        o, e, s = run_minesweeper(stdin_data: "0,0\n")
        aggregate_failures do
          expect(o).to include("💣")
          expect(o).to include("You lose")
          expect(o.end_with?("Goodbye\n")).to be(true)
        end
      end
    end

    context 'the user reveals all of the empty cells' do
      it 'tells the player they won' do
        o, e, s = run_minesweeper(stdin_data: "2,2\n")
        aggregate_failures do
          expect(o).not_to include("💣")
          expect(o).to include("You win")
          expect(o.end_with?("Goodbye\n")).to be(true)
        end
      end
    end
  end
end
