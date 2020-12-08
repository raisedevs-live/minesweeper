class Prompt
  class UserInputError < StandardError; end
  module STRINGS
    WELCOME = "Welcome to Minesweeper"
    REVEAL_AT  = "Enter the coordinates of the cell you would like to reveal."
  end

  def welcome
    puts STRINGS::WELCOME
  end

  def reveal_at
    puts STRINGS::REVEAL_AT
    coords_from(gets)
  end

  private

  def coords_from(input)
    raise UserInputError unless input =~ /^\d+,\d+$/
    x, y = input.split(',')
    { x: x.to_i, y: y.to_i }
  end
end
