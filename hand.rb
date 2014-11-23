require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'hand_rankings'

class Hand
	include HandRankings
	
	attr_accessor :cards # for debugging
	
	# creates new Hand obj with 5 cards
	def self.deal_from(deck)
		cards = deck.take(5) # takes top 5 as arr of Cards
		Hand.new(cards)
	end
	
	def initialize(cards)
		@cards = cards
	end
	
	# returns -1, 0, 1 depending on score < other_hand.score 
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
		cards.max_by{|c| c.value }
	end
	
	def render 
		puts self.cards.map{|c| c.render }.join(", ")
	end
	
	protected
	
	private 
	
	# if equal rank, look at high_card - return -1, 0, 1
	def tiebreak(other_hand)
		multiple_ranks = Proc.new{ |rank| [:one_pair, :two_pair, :three_of_a_kind, :four_of_a_kind].include?(rank) }
		case rank 
		when :flush # straight flushes go by high_card
			sorted_cards = self.cards.sort.reverse
			other_cards = other_hand.cards.sort.reverse
			compare_cards(sorted_cards, other_cards)
		when :full_house # first high of three, then high of pair
			three = cards.select{ |c| cards.count(c) == 3 }.first
			other_three = cards.select{ |c| cards.count(c) == 3 }.first
			return three <=> other_three unless (three <=> other_three).zero?
			
			pair, other_pair = pairs.first, other_hand.pairs.first
			pair <=> other_pair
		when multiple_ranks
			# the non-singles in descending order
			return compare_cards(self.multiples, other_hand.multiples) unless compare_cards(self.multiples, other_hand.multiples).zero?

			# else, need to look at single cards (kickers)
			compare_cards(self.singles, other_hand.singles)
		else # straight, straight flush, high card
			high_card <=> other_hand.high_card
		end
	end
	
	# compares two arrays of cards for first tiebreaker
	def compare_cards(cards1, cards2)
		cards1.each_index do |i| 
			sort_score = (cards1[i] <=> cards2[i])
			return sort_score unless sort_score.zero?
		end
		
		0
	end
	
	
end