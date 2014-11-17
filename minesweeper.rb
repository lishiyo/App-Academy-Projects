class Board
  attr_reader :size

  def initialize (size = 9)
    @grid = Board.create_grid(size)
    @size = size
  end

  def self.create_grid(size)
    empty_grid = Array.new(size){ Array.new (size) }
    empty_grid.map.with_index do |row, row_i|
      row.map.with_index do |col, col_i|
        Tile.new(self, [row_i, col_i])
      end
    end
  end

  def seed_grid

  end

  def [] (row, col)
    @grid[row][col]
  end

  private
  def inspect
  end
end

class Tile

  INCREMENTS = [0,1,-1,1,-1].permutation(2).to_a.uniq

  attr_reader :position
  attr_accessor :bombed, :flagged, :revealed

  def initialize (grid, position)
    @grid = grid
    @position = position
    @bombed = false
    @flagged = false
    @revealed = false
  end

  def neighbors
    neighbors = []
    INCREMENTS.each do |increment|
      new_pos = [position[0] + increment[0], position[1] + increment[1]]
      if new_pos[0].between?(0, @grid.size - 1) &&
        new_pos[1].between?(0, @grid.size - 1)
        neighbors << new_pos
      end
    end

    neighbors
  end

  private
  def inspect
  end


end
