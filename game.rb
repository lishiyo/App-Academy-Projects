require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'player'

class Game
	
	attr_reader :players, :pot
	
	# initialize with any num of players and a new deck
	def initialize(*players)
		@players = players
		@deck = Deck.create_deck # array of 52 cards
		@pot = 0
		@starting_better = players.first
	end
	
	def play
		play_round until game_over?
	end
 
	def play_round 
		# each player gets new hand
		@deck.shuffle!
		players.each do |player| 
			player.folded = false # unfold players each round
			player.get_hand(@deck)
		end
		# betting round begins to grow pot
		# end round and pay winnings if everyone but one player folds
		take_round_bets
		(end_round && return) if round_over?
		# allow each player to discard and get new cards from deck
		update_hands 
		# last betting round
		take_round_bets 
		# show hands
		end_round
	end
	
	# take bets and add to round's pot until no one raises
	# each player may fold, see the curr bet, or raise
	def take_round_bets
		
	end
	
# Round ends when all players have bet an equal amount or everyone folds to a bet or raise. If no opponents call, the player wins the pot.
	def round_over? 
	
	end

	# each player can discard up to 3 cards
	def update_hands
		
	end
	
	# IF any players do not fold, then players reveal their hands; strongest hand wins the pot.
	def end_round 
		
	end
	
	def show_hands

	end

	def add_to_bet

	end
	
end