class HumanPlayer
	
	def initialize
	end
	
	# AS GUESSER
	
	def receive_secret_length(board)
		@guessed_letters = []
		board.render
	end
	
	def make_guess
		puts "Pick a letter!"
		
		begin
			letter = gets.chomp.downcase	
			raise "oops, try again! Must have guessed that before!" unless (letter =~ /[a-z]/ && !@guessed_letters.include?(letter))
		rescue Exception => e
			puts e.message
			retry
		end
		
		@guessed_letters << letter
		letter
	end
	
	def handle_guess_response(board)
		#board.render
	end
	
	# AS CHECKER
	
	def pick_secret_word
		
		puts "Pick a secret word and enter in how long it is."
		begin
			res = gets.chomp
			length = Integer(res)
		rescue
			puts 'woops, has to be a number!'
			retry
		end
		
		length
	end
		
	
	def check_guess(guess)
		puts "Computer guessed: #{guess}."
		puts "Which indices, if any does letter occur at? For example, type in 1 2 if the guess was 'p' and your word was 'apple'. If none, hit enter."
		
		begin
			response = gets.chomp
			hits_arr = response.split
			return hits_arr if hits_arr.empty? # hit enter
			
			hits_arr.map!{|n| Integer(n) }
		rescue ArgumentError
			puts "Only numbers are valid. Hit return if none."
			retry
		end
		
		hits_arr
	end
	
	def reveal_secret
		puts "a'ight, squirt. What was it?"
		secret = gets.chomp
		puts "Looks like it was #{secret}!"
	end
	
end

