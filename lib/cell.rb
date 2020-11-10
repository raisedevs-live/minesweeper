class Cell
  def initialize(mine: false)
    raise ArgumentError unless [true, false].include? mine

    @mine = mine
  end

  def mine?
    @mine
  end
end
