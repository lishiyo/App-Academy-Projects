#!/usr/bin/env ruby

require 'yaml'
require './minesweeper.rb'

class Game

  attr_reader :board

  def initialize(difficulty = :e)
    @board = Board.new(difficulty)
    load
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
    puts "If you ever want to save, just type s."
    puts "If you ever want to delete your save, type d."
    puts "HAVE FUN!\n"
  end

  def play_turn
    render
    begin
    puts "What move would you like to make?"
    input = gets.chomp.split(" ")
    position = [input[1], input[2]].map(&:to_i)
    unless position.all? { |num| num.between?(0, @board.grid.size - 1) }
      raise RuntimeError, "Invalid Position"
    end
    case input[0]
    when "s" then save
    when "d" then delete_save
    when "r" then board[position].reveal
    when "f" then board[position].flag
    when "n" then finish_game
    when "q"
      save
      exit
    else
      puts "Can you please do it right next time? -_-;;"
    end
    rescue RuntimeError => e
      puts e.message
      retry
    end

    nil
  end

  def render
    print "".ljust(4)
    board.grid.length.times do |col_i|
      print "#{col_i}".ljust(4)
    end
    print "\n"
    board.grid.each_with_index do |row, row_i|
      print "#{row_i}".ljust(4)
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
    delete_save
  end


  def save
    f = File.open('minesweeper_saved.txt', "w")
    f.write(@board.to_yaml)
    f.close
  end

  def load
    if File.exist?('minesweeper_saved.txt')
      saved_game = File.read('minesweeper_saved.txt')
      @board = YAML.load(saved_game)
    end
  end

  def delete_save
    File.delete("minesweeper_saved.txt") if File.exist?("minesweeper_saved.txt")
  end
end

if __FILE__ == $PROGRAM_NAME
  loop do
    unless File.exist?('minesweeper_saved.txt')
      puts "Which difficulty level would you like to play? (e/m/h)"
      difficulty = gets.chomp.downcase
      if difficulty =~ /^([emh])$/i
        game = Game.new(difficulty.to_sym)
      else
        puts "Invalid difficulty level. Type in e, m, or h."
      end
    else
      game = Game.new
      game.run_game
      puts "Play again? (y/n)"
      break if gets.chomp == "n"
    end
  end
end
