class Prompt
  class UserInputError < StandardError; end
  module STRINGS
    WELCOME = "Welcome to Minesweeper"
    REVEAL_AT  = "Enter the coordinates of the cell you would like to reveal."
    LOSE = "You lose"
    WIN = "You win"
    EXIT = "Goodbye"
  end

  def welcome
    puts STRINGS::WELCOME
  end

  def reveal_at
    puts STRINGS::REVEAL_AT
    coords_from(gets)
  end

  def lose
    puts STRINGS::LOSE
  end

  def win
    puts STRINGS::WIN
  end

  def exit
    puts STRINGS::EXIT
  end

  private

  def coords_from(input)
    raise UserInputError unless input =~ /^\d+,\d+(:\d+,\d+)*$/
    targets = input.split(':')
    targets.map do |target|
      x, y = target.split(',')
      { x: x.to_i, y: y.to_i }
    end
  end
end
