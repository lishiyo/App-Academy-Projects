class Card
	 CARD_VALUES = {
    :two    => 2,
    :three  => 3,
    :four   => 4,
    :five   => 5,
    :six    => 6,
    :seven  => 7,
    :eight  => 8,
    :nine   => 9,
    :ten    => 10,
    :jack   => 11,
    :queen  => 12,
    :king   => 13,
    :ace    => 14
  }

   CARD_STRS = {
    2  => "2",
    3  => "3",
    4  => "4",
    5  => "5",
    6  => "6",
    7  => "7",
    8  => "8",
    9  => "9",
    10 => "10",
    11 => "J",
    12 => "Q",
    13 => "K",
    14 => "A"
  }

  SUIT_STRS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }
	
	attr_reader :value, :suit
	
	def initialize(value, suit)
		@suit = suit
		@value = CARD_VALUES[value]
	end
	
	# compare by value then suit
	def <=>(other_card)
		return 0 if self == other_card 
		# check value first
		if self.value != other_card.value
			self.value < other_card.value ? -1 : 1
		else # same val, diff suit 
			idx = Card.suits.index(self.suit)
			other_idx = Card.suits.index(other_card.suit)
			idx < other_idx ? -1 : 1
		end
	end
	
	def self.suits
		SUIT_STRS.keys
	end
	
	def self.values
		CARD_VALUES.keys
	end
	
	def ==(other_card)
		suit == other_card.suit && value == other_card.value
	end
	
	def render
		"#{CARD_VALUES.key(value)} of #{suit}"
	end

	def dup
		Card.new(value, suit)
	end
	
end