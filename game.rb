#!/usr/bin/env ruby

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
	
	# passes around a board between guesser and checker
	def run
		# initialize board with length
		length = checker.pick_secret_word # picks a word, returns length
		@board = Board.new(length)
		guesser.receive_secret_length(@board)
		
		until @misses > MAX_MISSES
			
			# return letter 
			guess = guesser.make_guess
			
			# rescue human putting in wrong indices
			begin
				# return array of hits given guess
				hits_arr = checker.check_guess(guess) 
				# update @board if there was a hit; else, increment misses
				hits_arr.empty? ? @misses +=1 : update_board(hits_arr, guess) 
			rescue Exception => e
				puts e.message
				retry
			end
			
			# break if the board is over
			won if @board.filled?
	
			# if not over, pass updated board to guesser 
			guesser.handle_guess_response(@board)
			
			# render new board
			@board.render
		end
		
		# Guesser lost
		puts "The guesser lost!"
		checker.reveal_secret
		
	end
	
	private 
	
	def won
		@board.render
		puts "The guesser got it with #{MAX_MISSES - @misses} to go!"
		exit
	end
	
	def update_board(hits_arr, guess)
		# make sure HumanPlayer can't enter indices outside range or already filled
		raise 'woops, are you sure you entered the right indices?' unless hits_arr.all?{|i| @board[i].nil? } && hits_arr.none?{|i| i >= @board.bar.length }
		
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
		p1, p2 = HumanPlayer.new, ComputerPlayer.new
	when 2
		p2, p1 = HumanPlayer.new, ComputerPlayer.new
	else
		raise "Sorry, not a valid response!"
	end
	rescue
		retry
	end
	
	game = Game.new(p1, p2)
	game.run
end