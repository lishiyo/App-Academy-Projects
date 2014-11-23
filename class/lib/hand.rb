# The logic of calculating pair, three-of-a-kind, two-pair,
# Which hand beats which

require_relative 'card'
require_relative 'deck'


class Hand

  HANDS = {
    :pair           => 2,
    :three_of_kind  => 3,
  }

  attr_reader :value, :high

  # array of cards
  def initialize(cards)
    @cards = cards
  end

  def <=>(other_hand)
    if value < other_hand.value
      -1
    elsif value > other_hand.value
      1
    else
      if high < other_hand.high
        -1
      elsif high > other_hand.high
        1
      end
    end

    0
  end

  def get_hand_value
  end

  def check_flush
    suits = get_suits

    if suits.uniq.count == 1
      return get_values.max
    end

    0
  end

  def check_straight
    values = get_values.uniq
    return 0 if values.length < 5

    values.sort!
    if values.last == 14
      if values[-2] == 5 && (values[-2] - values[0] == 3)
        return values.max
      elsif values.max - values.min == 4
        return values.max
      end
    else
      if values.max - values.min == 4
        return values.max
      end
    end

    0
  end

  def check_pair
    vals = get_values

    if vals.uniq.count == 4
      high = vals.select { |v| vals.count(v) == 2 }[0]
      return high
    end

    0
  end

  def check_two_pair
    vals = get_values

    pairs = vals.select { |v| vals.count(v) == 2 }

    return pairs.max if pairs.length == 2
    0
  end

  def check_three_of_kind
    vals = get_values

    pairsplus = vals.select { |v| vals.count(v) >= 2 }

    return pairsplus[0] if pairsplus.length == 1

    0
  end

  def check_four_of_kind
    vals = get_values

    four = vals.select { |v| vals.count(v) == 4 }

    return four[0] unless four.empty?
    0
  end

  def check_full_house
    vals = get_values

    return 0 unless vals.uniq == 2

    three = vals.select { |v| vals.count(v) == 3 }

    return 0 if three.empty?

    three
  end

  def get_suits
    suits = []
    @cards.each { |c| suits << c.suit }
    suits
  end

  def get_values
    vals = []
    @cards.each { |c| vals << c.value }
    vals
  end

  # removes 0 to 3 cards from hand
  def discard_cards(cards)

  end

  # gives the same number back to the hand
  def replace_cards(new_cards)
  end

  def render
  end



end
