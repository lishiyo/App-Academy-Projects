class Board
  attr_reader :size

  def initialize (size = 9)
    @board = Board.create_board(size)
    @size = size
  end

  def self.create_board(size)
    Array.new(size){ Array.new (size) }
  end

  def seed_board

  end

  def [] (position)
    @board[position[0]][position[1]]
  end
end

class Tile

  INCREMENTS = [0,1,-1,1,-1].permutation(2).to_a.uniq

  attr_reader :position

  def initialize (board, position)
    @board = board
    @position = position
    @bombed = false
    @flagged = false
    @revealed = false
  end

  def neighbors
    neighbors = []
    INCREMENTS.each do |increment|
      new_pos = [position[0] + increment[0], position[1] + increment[1]]
      if new_pos[0].between?(0, @board.size - 1) &&
        new_pos[1].between?(0, @board.size - 1)
        neighbors << new_pos
      end
    end

    neighbors
  end


end
