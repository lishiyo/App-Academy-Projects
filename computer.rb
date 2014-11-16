class ComputerPlayer
	
	DICT = File.readlines('dictionary.txt').map(&:chomp)
	
	def initialize
		@dictionary = DICT
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
		puts "The secret word was: #{@secret}."
	end
	
	# AS GUESSER
	# initiate board, valid_words, guessed_letters
	def receive_secret_length(board)
		@board = board
		@valid_words = @dictionary.dup
			.reject{|word| word.length != board.bar.length }
		@guessed_letters = []
	end
	
	# return most frequent letter in valid words not guessed before
	def make_guess
		begin
			highest_letter_left = freq_hash
				.sort_by{|k, v| v}
				.reverse
				.map{|char, freq| char}
				.detect{|char| !@guessed_letters.include?(char)}
			raise "Aw, damn! Got nothin' left. Let's start a new game." unless highest_letter_left
		rescue Exception => e
			puts e.message
			exit
		else
			@guessed_letters << highest_letter_left
			highest_letter_left
		end
	end
	
	# pare down valid words given new board ['a', nil, 'p', nil, 'e']
	def handle_guess_response(board)
		@board = board
		# remove word if this word[i] != board.bar[i]
		# remove word if letter matches but count is wrong
		@board.bar.each_with_index do |char, i|
			next if char.nil?
			
			@valid_words.delete_if do |word| 
				word[i] != char || word.count(char) != board.bar.count(char)
			end
		end
		
		@valid_words
	end
	
	private
	
	# freq_hash returns {a => 24, b => 50...} for empty spaces
	def freq_hash
		freq_hash = Hash.new(0)
		@board.bar.each_index do |i| # ['a', nil, 'p', nil, 'e']
			next unless @board[i].nil? # only look at empty spaces
			@valid_words.each { |word| freq_hash[word[i]] += 1 }
		end
		
		freq_hash
	end
	
end