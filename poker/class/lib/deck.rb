require_relative 'card'

class Deck

  # creates array of all 52 cards
  def self.all_cards
    deck = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        deck << Card.new(value, suit)
      end
    end

    deck
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  # Draws num cards from the top of the deck
  def draw(num)
    raise "not enough cards" if count < num
    @cards.shift(num)
  end

  def count
    @cards.length
  end

end
