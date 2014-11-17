require './minesweeper.rb'

class Game

  def initialize
    run_game
  end

  def run_game
    @board = Board.new
    loop do
      render
      position = gets.chomp.split(" ").map(&:to_i)
      @board[position[0], position[1]].reveal
    end
  end

  def render
    @board.grid.each_with_index do |row, row_i|
      row.each_with_index do |tile, col_i|
        if tile.bombed? && tile.revealed?
          print "☠ "
        elsif tile.flagged?
          print "⚑ "
        elsif tile.revealed?
          bomb_count = tile.neighbor_bomb_count
          print "#{bomb_count.zero? ? "□" : bomb_count} "
        else
          print "■ "
        end
      end
      print "\n"
    end
  end

end
