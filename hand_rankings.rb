require_relative 'card'
require_relative 'hand'

# Logic of calculating max possible hand score and which hand beats which 

module HandRankings
	
	RANKINGS = [:straight_flush, :four_of_a_kind, :full_house, :flush, :straight, :three_of_a_kind, :two_pair, :one_pair, :high_card]
	
	# return sym of highest ranking possible (EX: :one_pair)
	def rank
		RANKINGS.each do |ranking|
			return ranking if self.send("#{ranking}?".to_sym)
		end
	end
	
	def straight_flush? 
		straight? && flush?
	end
	
	def four_of_a_kind?
		cards.any?{|c| cards.count(c) == 4}
	end
	
	def full_house? 
		cards.uniq.size == 2 && pairs.size == 1 
	end
	
	def flush? 
		card_suits.uniq.size == 1
	end
	
	def straight? 
		card_vals = card_values
		return false unless card_vals.uniq.size == 5
		
		# regular straight 2..6 and high ace 10..14
		if (card_vals.max - card_vals.min == 4)
			return true 
		elsif card_vals.include?(14)
			# low ace A,2,3,4,5
			return true if card_vals.sort[0]==2 && card_vals.sort[-2] == 5
		end
		
		false
	end
	
	def three_of_a_kind?
		# don't need to check for flush because flush is called earlier
		cards.any?{|c| cards.count(c) == 3}
	end
	
	def two_pair?
		pairs.size == 2
	end 
	
	def one_pair? 
		pairs.size == 1
	end
	
	def high_card? 
		cards.uniq.size == 5 && !flush?
	end
	
	# cards that are exactly pairs
	def pairs
		cards.select{|c| cards.count(c) == 2 }.uniq
	end
	
	private
	
	def card_values
		cards.map{|c| c.value }
	end
	
	def card_suits 
		cards.map{|c| c.suit }
	end
	
	
	
end