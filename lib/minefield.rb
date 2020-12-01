class Minefield
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

  private

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
    @field = []
    @height.times do
      row = []
      @width.times do
        row << Cell.new
      end
      @field << row
    end
  end
end
