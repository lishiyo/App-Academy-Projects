require_relative 'card'
require_relative 'deck'
require_relative 'hand'


class PokerError < StandardError
end

class BadInputError < StandardError
end

class Player
	
	attr_reader :name, :bankroll, :net_winnings
	attr_accessor :folded, :hand, :raised, :betted
	
	def initialize(name, bankroll)
		@name = name 
		@bankroll = bankroll
		@net_winnings = 0
		@folded = false
	end
	
	def folded? 
		@folded 
	end
	
	def raised? 
		@raised
	end
	
	def betted?
		@betted
	end
	
	def get_new_hand(deck)
		@hand = Hand.new_hand(deck) # new hand of 5 cards
	end
	
	# game pays out winnings
	def take_winnings(winnings)
		@bankroll += winnings
		@net_winnings += winnings
	end
	
	# game takes player's bet
	def take_bet(bet_amt)
		raise PokerError if bet_amt > bankroll 
		
		@bankroll -= bet_amt
		@net_winnings -= bet_amt
	end
	
	# return how much wish to bet
	def get_bet
		puts "#{name}, your current bankroll is $#{bankroll}. Your hand:"
		@hand.render
		puts "How much do you wish to bet?"
		
		begin
			input = gets.chomp
			return input if input == 'fold'
			raise BadInputError unless input =~ /^\d+$/ 
			raise BadInputError unless Integer(input).between?(0, bankroll)
		rescue
			puts "Bet must be greater than zero and smaller than your current bankroll. If you wish to quit and fold on this bet, enter 'fold'."
			retry
		end
		
		input.to_i
	end
	
	# return which card indices to discard (0 to 4, for 1 to 5)
	def get_discard
		puts "#{name}, what cards do you wish to discard?" 
		@hand.render
		puts "Choose up to 3 (EX: 1 4). Press enter if you don't want to discard any."
		begin
			input = gets.chomp
			raise BadInputError unless input.split.size <= 3 && input.split.all? do |num| 
				num =~ /^[1-5]$/
			end
		rescue
			puts "You must enter in numbers b/t 1 to 5 separated by spaces."
			retry
		end
		
		input.split.map(&:to_i).map{ |i| i - 1 }
	end
	
	# given discard card indices, discard them and take same num to hand
	def update_hand(discard_idx, deck)
		discard_cards = discard_idx.reduce([]) do |discards, idx|
			discards << @hand.cards[idx]
		end
		# discard cards
		discard_cards.each{ |c| @hand.cards.delete(c) }
		# replace with new
		new_cards = deck.take(discard_cards.size)
		@hand.cards.push(*new_cards)
		
		puts "#{name}'s new hand is:"
		@hand.render
		
		@hand
	end
	
	# returns :fold, :see, or :raise
	def get_move
		puts "Your current bankroll is $#{bankroll}, and your hand is:"
		@hand.render 
		puts "Do you wish to fold, see the bet, or raise?"
		begin
			input = gets.chomp.downcase
			raise BadInputError unless ['fold', 'see', 'raise'].include?(input)
			input.to_sym
		rescue
			puts "You must input 'fold', 'see', or 'raise'."
			retry
		end
	end
	
	def inspect
		"#{name}, #{bankroll}, #{net_winnings}"
	end
	
end