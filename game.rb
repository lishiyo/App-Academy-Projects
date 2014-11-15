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
	
	# set board[2] = 'a'
	def []=(idx, letter)
		@bar[idx] = letter
 	end
	
	# read board[2] = 'a'
	def [](idx)
		@bar[idx]
	end
	
end

class Game
	
	MAX_MISSES = 6
	
	attr_reader :guesser, :checker
	
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
		
		until @misses > MAX_MISSES
			
			# return letter given current board
			guess = guesser.make_guess 
	
			begin
				# return array of hits given guess
				hits_arr = checker.check_guess(guess) 
				# update @board if there was a hit; else, increment misses
				hits_arr.empty? ? @misses +=1 : update_board(hits_arr, guess) 
			rescue
				puts "try checking your indices again!"
				retry
			end
			
			# break if the board is over
			won if @board.filled?
	
			# if not over, pass updated board arr to guesser 
			guesser.handle_guess_response(@board)
	
			@board.render
		end
		
		# guesser lost
		puts "The guesser lost!"
		checker.reveal_secret
		
	end
	
	private 
	
	def won
		remaining_rounds = MAX_MISSES - @misses
		puts "The guesser got it with #{remaining_rounds} to go!"
		exit
	end
	
	def update_board(hits_arr, guess)
		raise 'woops, already letters there!' unless hits_arr.all?{|i| @board[i].nil? }
		
		@board.bar.map.with_index do |space, idx|
			@board[idx] = guess if hits_arr.include? idx
		end
	end
	
end

if __FILE__ == $PROGRAM_NAME
	puts "Do you want to 1) play the computer or 2) make up a word and let the computer play you? Enter 1 or 2."
	begin
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
	rescue
		retry
	end
	
	game = Game.new(p1, p2)
	game.run
end