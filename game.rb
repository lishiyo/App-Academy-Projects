require './minesweeper.rb'

class Game

  attr_accessor :board

  def initialize
    run_game
  end

  def run_game
    @board = Board.new
    until over?
      render
      position = gets.chomp.split(" ").map(&:to_i)
      @board[position[0], position[1]].reveal
    end

    finish_game
  end

  private

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

  def over?
    won? || lost?
  end

  def won?
    @board.grid.flatten.none?{|tile| tile.revealed? == false && tile.bombed? == false}
  end

  def lost?
    @board.grid.flatten.any?{|tile| tile.revealed? && tile.bombed? }
  end

  def finish_game
    puts won? ? "You won. Play again? (y/n)" : "You lost. Play again? (y/n)"
    run_game if gets.chomp == "y"
  end
end
