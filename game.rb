#!/usr/bin/env ruby

# The Game.new method takes guessing_player and checking_player arguments; the game should not treat a computer player any differently than a human player.

require './computer.rb'
require './human.rb'

class Board
	attr_accessor :bar
	
	def initialize(length)
		@bar = Array.new(length, nil)
	end
	
	def render
		bar = @bar.map do |el|
			el.nil? ? "_" : "#{el}"
		end.join(" ")
		
		puts "Secret word: #{bar}"
	end
	
	def filled?
		bar.none?{|space| space.nil? }
	end
	
# 	def []=(idx, val)
# 		@bar[idx] = val
# 	end
	
end

class Game
	
	MAX_MISSES = 6
	
	attr_reader :guesser, :checker, :board
	
	def initialize(p1, p2)
		@guesser = p1
		@checker = p2
		@misses = 0
	end
	
	# passes around a board, receives hits array
	def run
		length = checker.pick_secret_word # picks a word, returns length
		@board = Board.new(length)
		guesser.receive_secret_length(@board)
		puts checker.secret
		
		until @misses > MAX_MISSES
			
			# return letter given current board
			guess = guesser.make_guess 
			# return array of hits given guess
			hits_arr = checker.check_guess(guess) 
			# update @board if there was a hit; else, increment misses
			hits_arr.empty? ? @misses +=1 : update_board(hits_arr, guess) 
			
			# break if the board is over
			Game.won if @board.filled?
	
			# if not over, pass updated board to guesser 
			guesser.handle_guess_response(board)
	
		end
		
		# guesser lost
		puts "The guesser lost!"
		checker.reveal_secret
		
	end
	
	private 
	
	def self.won
		puts "The guesser got it!"
		exit
	end
	
	def update_board(hits_arr, guess)
		@board.bar.map.with_index do |space, idx| 
			@board.bar[idx] = guess if hits_arr.include? idx
		end
	end
	
end

if __FILE__ == $PROGRAM_NAME
	puts "Do you want to 1) play the computer or 2) make up a word and let the computer play you? Enter 1 or 2."
	response = gets.chomp.chars.map(&:to_i).first
	case response
	when 1
		p1 = HumanPlayer.new
		p2 = ComputerPlayer.new
	when 2
		p2 = HumanPlayer.new
		p1 = ComputerPlayer.new
	else
		raise "Sorry, not a valid response!"
	end
	
	game = Game.new(p1, p2)
	game.run
end