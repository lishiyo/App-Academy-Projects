require 'set'

class WordChainer
	
	def initialize(dictionary_filename, *args)
		@dictionary = File.readlines(dictionary_filename).map(&:chomp).to_set
	end
	
	# all words one letter different
	def adjacent_words(word)
		adj_words = []
		word.chars.each_with_index do |char, i|
			('a'..'z').to_a.each do |letter|
				next if char == letter # change 25 times for each letter
				
				new_word = word.dup
				new_word[i] = letter
				adj_words << new_word if @dictionary.include?(new_word)
			end
		end
		
		adj_words
	end
	
	
end

w = WordChainer.new("dictionary.txt")
p w.adjacent_words("duck")