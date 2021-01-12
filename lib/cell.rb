class Cell
  module HintError
    class CannotSet < StandardError; end
    class HasMine < StandardError; end
    class Unknown < StandardError; end
  end

  def initialize(mine: false)
    raise ArgumentError unless [true, false].include? mine

    @mine = mine
    @neighboring_mine_count = nil
    @revealed = false
  end

  def hint
    raise HintError::HasMine if mine?
    raise HintError::Unknown if @neighboring_mine_count.nil?
    @neighboring_mine_count
  end

  def hint=(neighboring_mine_count)
    raise HintError::CannotSet if mine?
    raise ArgumentError unless (0..8).include?(neighboring_mine_count)
    @neighboring_mine_count = neighboring_mine_count
  end

  def mine?
    @mine
  end

  def reveal!
    @revealed = true
    self
  end

  def revealed?
    @revealed
  end

  def inspect
    "<Cell:revealed: #{@revealed}, mine: #{@mine}>"
  end
end
