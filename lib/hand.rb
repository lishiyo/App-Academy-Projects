require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'hand_rankings'
require 'colorize'

class Hand
	include HandRankings
	
	attr_reader :cards
	
	# creates new Hand obj with 5 cards
	def self.new_hand(deck)
		cards = deck.take(5) # takes top 5 as arr of Cards
		Hand.new(cards)
	end
	
	def self.highest_hand(hands)
		hands.max
	end
	
	def initialize(cards)
		@cards = cards.sort
	end
	
	# always 1 or -1 
	def <=>(other_hand) #{|n1, n2| n1 <=> n2}
		# leads to tiebreaker
		if rank == other_hand.rank
			tiebreak(other_hand)
		else 
			rankings = HandRankings::RANKINGS
			my_rank = rankings.index(rank)
			other_rank = rankings.index(other_hand.rank)
			my_rank < other_rank ? 1 : -1
		end
	end
	
	# return highest card in hand
	def high_card 
		cards.max
	end
	
	def render 
		puts cards.sort.map{|c| c.render }
			.join(", ").colorize(:light_yellow)
	end
	
	private 
	
	def tiebreak(other_hand)
		multiple_ranks = Proc.new{ |rank| [:one_pair, :two_pair, :three_of_a_kind, :four_of_a_kind].include?(rank) }
		
		case rank 
		when :flush # straight flushes go by high card
			compare_cards(cards.sort.reverse, other_hand.cards.sort.reverse)
		when :full_house # first high of three, then high of pair
			three = cards.select{ |c| cards.count(c) == 3 }.first
			other_three = cards.select{ |c| cards.count(c) == 3 }.first
			return three <=> other_three unless (three <=> other_three).zero?
			
			pair, other_pair = pairs.first, other_hand.pairs.first
			pair <=> other_pair
		when multiple_ranks
			# the non-singles from highest to lowest
			unless compare_cards(self.multiples, other_hand.multiples).zero?
				return compare_cards(self.multiples, other_hand.multiples) 
			end
			# else, need to look at single cards (kickers)
			compare_cards(self.singles, other_hand.singles)
		else # straight, straight flush, high card
			high_card <=> other_hand.high_card
		end
	end
	
	# compares two card arrays for first tiebreaker
	def compare_cards(cards1, cards2)
		cards1.each_index do |i| 
			sort_score = (cards1[i] <=> cards2[i])
			return sort_score unless sort_score.zero?
		end
		
		0
	end
	
	
end