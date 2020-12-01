class MinefieldPrinter
  module STRINGS
    CLOSED_CELL = "⬜️"
    REVEALED_CELL = "🔲"
    MINE = "💣"
  end

  def initialize(minefield)
    raise ArgumentError unless minefield.class == Minefield
    @minefield = minefield
  end

  def to_s
    field = ""
    @minefield.rows.each do |row|
      row.each do |cell|
        field << character_for_cell(cell)
      end
      field << "\n"
    end
    field
  end

  private

  def character_for_cell(cell)
    return STRINGS::CLOSED_CELL unless cell.revealed?
    STRINGS::MINE
  end
end
