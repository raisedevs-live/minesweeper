require_relative './cell.rb'

class Minefield
  class OutOfBoundsError < StandardError; end

  def initialize(width:, height:, mine_count:, seed: :random)
    @width = width
    @height = height
    @mine_count = mine_count
    @seed = seed
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

  def mine_revealed?
    @field.flatten.select(&:revealed?).any?(&:mine?)
  end

  def cleared?
    return true if @field.flatten.reject(&:mine?).all?(&:revealed?)
    false
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

    unless (@seed == :none || @seed == :random || @seed.class == Integer)
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

    if @seed == :random
      cells.shuffle!
    elsif @seed.class == Integer
      cells.shuffle!(random: Random.new(@seed))
    end

    @field = []
    @height.times do
      row = []
      @width.times do
        row << cells.shift
      end
      @field << row
    end

    set_hints
  end

  def set_hints
    rows.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        hint = hint_for_cell_at(x, y)
        cell.hint = hint unless cell.mine?
      end
    end
  end

  def hint_for_cell_at(x, y)
    neighbors = []
    neighbor_coordinates = [
      { x: x-1, y: y },
      { x: x+1, y: y },
      { x: x, y: y-1 },
      { x: x, y: y+1 },
      { x: x-1, y: y-1 },
      { x: x+1, y: y+1 },
      { x: x-1, y: y+1 },
      { x: x+1, y: y-1 }
    ]

    neighbor_coordinates.each do |coords|
      neighbors << cell_at(coords.fetch(:x), coords.fetch(:y))
    rescue OutOfBoundsError
    end

    neighbors.reduce(0) { |count, cell| cell.mine? ? count + 1 : count }
  end
end
