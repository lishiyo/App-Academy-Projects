require './game.rb'

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
	# initiate valid_words as guesser
	def receive_secret_length(board)
		@valid_words = @dictionary.dup
			.reject{|word| word.length != board.length }
		@guessed_letters = []
	end
	
	# return most frequent letter in valid not guessed before
	def make_guess
		highest_letter_left = freq_hash
			.sort_by{|k, v| v}
			.reverse
			.map{|char, freq| char}
			.detect{|char| !@guessed_letters.include?(char)}
		
		highest_letter_left
	end
	
	# pare down valid words given new board ['a', nil, 'p', nil, 'e']
	def handle_guess_response(board)
		@board = board
		# remove word if this word[i] != board.bar[i]
		# remove word if letter matches but count is wrong
		@board.bar.each_index do |i|
			@valid_words.delete_if do |word| 
				word[i] != board[i] || word.count(char) != board.bar.count(char)
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