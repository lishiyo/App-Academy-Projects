require_relative 'card'
require_relative 'deck'
require_relative 'hand'

class Player
	
	attr_reader :name, :bankroll
	attr_accessor :folded
	
	def initialize(name, bankroll)
		@name = name 
		@bankroll = bankroll
		@folded = false
	end
	
	def folded? 
		@folded 
	end
	
	def get_hand(deck)
		@hand = Hand.deal_from(deck) # new hand of 5 cards
	end
	
	# game pays out winnings
	def take_winnings(winnings)
		@bankroll += winnings
	end
	
	# game takes player's bet
	def take_bet(bet_amt)
		@bankroll -= bet_amt
	end
	
	# get how much wish to bet
	def get_bet
		
	end
	
	# get which cards to discard (1 to 5)
	def get_discard
		
	end
	
	# given discard card indices, get rid of them and get same num to hand
	def update_hand(discard_cards)
	end
	
	
	# returns :fold, :see(call), :raise
	def get_move
		
	end
	
end