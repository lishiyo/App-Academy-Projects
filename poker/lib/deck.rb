require_relative 'card'

class PokerError < StandardError
end

class Deck
	
	#attr_reader :cards
	
	def self.create_deck
		cards = []
		Card.suits.each do |suit|
			Card.values.each do |value|
				cards << Card.new(value, suit)
			end
		end
		cards
	end
	
	def initialize(cards = Deck.create_deck)
		@cards = cards
	end
	
	# take n cards off take of deck
	def take(n)
		raise PokerError.new("not enough cards") if n > self.count
		@cards.shift(n)
	end
	
	def shuffle
		@cards.shuffle!
		self
	end
	
	def count
		@cards.count
	end
	
	def inspect
		@cards.map{|c| c.render }
	end
	
end