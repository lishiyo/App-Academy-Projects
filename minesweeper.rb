class Board
  def initialize (board = Board.create_board)
    @board = board
  end

  def self.create_board
    Array.new(9){ Array.new (9) }
  end

  def seed_board

  end
end
