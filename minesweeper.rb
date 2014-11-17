class Board
  attr_reader :size, :grid

  def initialize (size = 9, number_bombs = 10)
    @grid = Board.create_grid(size)
    @size = size
    @number_bombs = number_bombs

    add_bombs_to_grid
  end

  def self.create_grid(size)
    empty_grid = Array.new(size){ Array.new (size) }
    empty_grid.map.with_index do |row, row_i|
      row.map.with_index do |col, col_i|
        Tile.new(self, [row_i, col_i])
      end
    end

  end

  def add_bombs_to_grid
    placed_bombs = 0
    until placed_bombs == @number_bombs
      random_tile = self[rand(9), rand(9)]
      unless random_tile.bombed
        random_tile.bombed = true
        placed_bombs += 1
      end
    end

    nil
  end

  def [] (row, col)
    @grid[row][col]
  end

  private
  def inspect
    # grid.map do |row|
    #   row.map do |tile|
    #     tile.bombed
    #   end
    # end
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
