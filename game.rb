require './minesweeper.rb'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
    run_game
  end

  def run_game
    pre_game
    until over?
      play_turn
    end

    finish_game
  end

  private

  def pre_game
    puts "Let's play Minesweeper!"
    puts "To reveal a position, begin your input with an r"
    puts "To flag a position, begin your input with an f"
    puts "Then put which position you would like to reveal/flag"
    puts "For example, to reveal position (1,2) you should type 'r 1 2'"
    puts "HAVE FUN!"
  end

  def play_turn
    render
    begin
    puts "What move would you like to make?"
    input = gets.chomp.split(" ")
    position = [input[1], input[2]].map(&:to_i)
    unless position.all? { |num| num.between?(0, @board.grid.size - 1) }
      raise "Invalid Position"
    end
    if input[0] == "r"
      board[position].reveal
    elsif input[0] == 'f'
      board[position].flag
    else
      puts "Can you please do it right next time? -_-;;"
    end
    rescue Exception => e
      puts e.message
      retry
    end

    nil
  end

  def render
    print "  "
    board.grid.length.times do |col_i|
      print "#{col_i} "
    end
    print "\n"
    board.grid.each_with_index do |row, row_i|
      print "#{row_i} "
      row.each do |tile|
        print tile
      end
      print "\n"
    end
  end

  def over?
    won? || lost?
  end

  def won?
    board.grid.flatten.all? do |tile|
      (tile.revealed? && !tile.bombed?) ||
      tile.bombed?
    end
  end

  def lost?
    board.grid.flatten.any? { |tile| tile.revealed? && tile.bombed? }
  end

  def finish_game
    if won?
      board.grid.flatten.each do |tile|
        tile.flagged = true if tile.bombed?
      end
      render
      puts "You won!"
    else
      board.grid.flatten.each do |tile|
        tile.revealed = true if tile.bombed?
      end
      render
      puts "You lost."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  loop do
    game = Game.new
    game.run_game
    puts "Play again? (y/n)"
    break if gets.chomp == "n"
  end
end
