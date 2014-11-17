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
      input = gets.chomp.split(" ")
      if input[0] == "r"
        @board[input[1].to_i, input[2].to_i].reveal
      elsif input[0] == 'f'
        @board[input[1].to_i, input[2].to_i].flag
      else
        puts "Can you please do it right next time? -_-;;"
      end
    end

    finish_game
  end

  private

  def render
    print "  "
    @board.grid.length.times do |col_i|
      print "#{col_i} "
    end
    print "\n"
    @board.grid.each_with_index do |row, row_i|
      print "#{row_i} "
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
    if won?
      @board.grid.flatten.each do |tile|
        tile.flagged = true if tile.bombed?
      end
      render
      puts "You won. Play again? (y/n)"
    else
      @board.grid.flatten.each do |tile|
        tile.revealed = true if tile.bombed?
      end
      render
      puts "You lost. Play again? (y/n)"
    end
    run_game if gets.chomp == "y"
  end
end
