require './game.rb'

class ComputerPlayer
	
	DICT = File.readlines('dictionary.txt').map(&:chomp)
	
	def initialize

	end
	
	# AS CHECKER
	
	def pick_secret_word
		@secret = DICT.sample
	end
	
	# takes letter, returns hits array or [] if none
	def check_guess(guess)
		
	end
	
	# AS GUESSER
	def receive_secret_length(n)
		@dictionary = DICT.reject{|word| word.length != n }
	end
	
	# return a 
	def make_guess
		
	end
	
	
	def handle_guess_response
		
	end
	
	private
	
	
	
	
end