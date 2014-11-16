require 'set'

class WordChainer
	
	def initialize(dictionary_filename = 'dictionary.txt')
		@dictionary = File.readlines(dictionary_filename).map(&:chomp).to_set
	end
	
	def run(source, target)
		@dictionary = @dictionary.select{|word| word.length == source.length }
		@current_words = [source]
		@all_seen_words = { source => nil } # {'duck' => 'ruck'}
		
		until @current_words.empty? || @all_seen_words.has_key?(target)
			explore_current_words
		end

		build_path_to(target).each {|word| puts word }
	end
	
	private

	def build_path_to(target)
		path = [target]
		begin
			until @all_seen_words[path.last].nil?
				path << @all_seen_words[path.last]
			end

			raise "alas, there's no path in my dictionary to #{target}!" if path.size == 1
		rescue Exception => e
			p e.message
			exit
		end

		path.reverse
	end

	# build a move tree, populating all_seen_words with word => parent 
	def explore_current_words
		new_curr_words = []	# all new words 1, 2, 3...steps away
		@current_words.each do |curr_word|
			adjacent_words(curr_word).each do |adj_word|
				next if @all_seen_words.has_key?(adj_word) 
				# else, add new word to this layer
				new_curr_words << adj_word
				@all_seen_words[adj_word] = curr_word
			end
		end

		@current_words = new_curr_words # start new layer
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

if __FILE__ == $PROGRAM_NAME
	
	begin
		source, target = ARGV.shift, ARGV.shift
		raise "oops, the words have to be the same length!" unless source.length == target.length
	rescue Exception => e
		puts e.message
		exit
	end
	w = WordChainer.new
	w.run(source, target)
end

