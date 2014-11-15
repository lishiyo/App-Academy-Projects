# The Game.new method takes guessing_player and checking_player arguments; the game should not treat a computer player any differently than a human player.

require './computer.rb'
require './human.rb'

# 
class Board
	
	def initialize(length)
		@row = Array.new(length, nil)
	end
	
	def render
		bar = @row.map do |el|
			el.nil? "_" : "#{el}"
		end.join(" ")
		
		puts "Secret word: #{bar}"
	end
	
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
		
		while @misses <= MAX_MISSES
			
			guess = guesser.make_guess(@board) # return letter given current board
			hits_arr = checker.check_guess(guess) # return array of hits
			
			update_board(hits_arr, guess) unless hits_arr.empty? 
			
			Game.won if @board.none?{|space| space.nil? } 
			
			
		end
		
	end
	
	private 
	
	def self.won
		puts "Guesser won!"
	end
	
	def update_board(hits_arr, guess)
		@board = @board.map.with_index do |space, idx| 
			@board[idx] = guess if hits_arr.include? idx
		end
	end
	
end