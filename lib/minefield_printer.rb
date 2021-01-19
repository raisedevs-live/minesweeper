class MinefieldPrinter
  module STRINGS
    CLOSED = "⬜️"
    EMPTY = "🔲"
    MINE = "💣"
    HINTS = {
              1 => "1️⃣ ",
              2 => "2️⃣ ",
              3 => "3️⃣ ",
              4 => "4️⃣ ",
              5 => "5️⃣ ",
              6 => "6️⃣ ",
              7 => "7️⃣ ",
              8 => "8️⃣ "
            }
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
    return STRINGS::CLOSED unless cell.revealed?
    if cell.mine?
      STRINGS::MINE
    elsif cell.hint == 0
      STRINGS::EMPTY
    else
      STRINGS::HINTS[cell.hint]
    end
  end
end
