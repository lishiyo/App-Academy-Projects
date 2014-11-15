require './game.rb'

class ComputerPlayer
	
	attr_reader :secret
	DICT = File.readlines('dictionary.txt').map(&:chomp)
	
	def initialize
	end
	
	# AS CHECKER
	def pick_secret_word
		@secret = DICT.sample
		
		@secret.length
	end
	
	# takes letter, returns array of idx or [] if none
	def check_guess(guess)
		hits_arr = []
		@secret.chars.each_index do |idx|
			hits_arr << idx if guess == @secret[idx]
		end
		
		hits_arr
	end
	
	def reveal_secret
		puts "The secret word was: #{@secret}"
	end
	
	# AS GUESSER
	def receive_secret_length(board)
		@dictionary = DICT.reject{|word| word.length != board.length }
	end
	
	# return a 
	def make_guess
		
	end
	
	
	def handle_guess_response
		
	end
	
	private
	
	
	
	
end