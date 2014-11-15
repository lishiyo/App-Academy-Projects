# require './game.rb'

class HumanPlayer
	
	def initialize
	end
	
	# AS GUESSER
	
	def receive_secret_length(board)
		board.render
	end
	
	def make_guess
		puts "Pick a letter!"
		
		begin
			letter = gets.chomp.downcase	
			raise "oops try again" unless (letter =~ /[a-z]/)
		rescue
			retry
		end
		
		letter
	end
	
	def handle_guess_response(board)
		board.render
	end
	
end
