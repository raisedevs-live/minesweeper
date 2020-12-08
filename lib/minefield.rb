require_relative './cell.rb'

class Minefield
  class OutOfBoundsError < StandardError; end

  def initialize(width:, height:, mine_count:)
    @width = width
    @height = height
    @mine_count = mine_count
    validate_arguments!
    initialize_field
  end

  def rows
    @field
  end

  def reveal_at(x, y)
    check_bounds!(x, y)
    cell = cell_at(x, y)
    cell.reveal!
  end

  def cell_at(x, y)
    check_bounds!(x, y)
    @field[y][x]
  end

  private

  def check_bounds!(x, y)
    raise OutOfBoundsError if (
      x < 0 ||
      x >= @width ||
      y < 0 ||
      y >= @height
    )
  end

  def empty_cell_count
    (@width * @height) - @mine_count
  end

  def validate_arguments!
    valid = true

    if (@width <= 0 || @height <= 0 || @mine_count <= 0)
      valid = false
    end

    if (@width.class != Integer || @height.class != Integer || @mine_count.class != Integer)
      valid = false
    end

    if (@width*@height < @mine_count)
      valid = false
    end

    raise ArgumentError unless valid
  end

  def initialize_field
    cells = []

    @mine_count.times do
      cells << Cell.new(mine: true)
    end

    empty_cell_count.times do
      cells << Cell.new
    end

    # TODO: Randomize the cells

    @field = []
    @height.times do
      row = []
      @width.times do
        row << cells.pop
      end
      @field << row
    end
  end
end
