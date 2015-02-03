require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'game'

class BadInputError < StandardError
end

class Player

  attr_reader :money, :name
  attr_accessor :hand

  def initialize(name, money)
    @name, @money = name, money
  end

  def get_hand(deck)
    @hand = Hand.new(deck.draw(5))
  end

  # returns which cards they wish to discard
  def get_discard
    #@hand.render
    puts "Please choose up to 3 cards to discard."
    puts "Indicate your cards with numbers 1 to 5 (EX: 2 3)."
    puts "If you don't want to discard anything, just press enter."
    input = gets.chomp
    parse_discard(input)
  end

  def parse_discard(input)
    input = input.split
    raise BadInputError if input.size > 3
    raise BadInputError if input.any? { |num| num !~ /^[1-5]$/ }

    input.map(&:to_i)
  end

  # returns whether they wish to fold, see, or raise
  def get_move
    #@hand.render
    puts "Enter whether you wish to fold (f), see (s), or raise (r)."
    input = gets.chomp
    parse_move(input)
  end

  def parse_move(input)
    input.downcase!

    case input
    when 'f' then return :fold
    when 's' then return :see
    when 'r' then return :raise
    end

    raise BadInputError
  end

  # get how much they wish to bet
  def place_bet
    puts "How much do you wish to bet?"
    input = gets.chomp
    parse_bet(input)
  end

  def parse_bet(input)
    raise BadInputError if input !~ /^(\d+)$/
    bet = $1.to_i
    raise BadInputError if bet > money
    bet
  end

  def take_bet(bet_amt)
    @money -= bet_amt
  end

  def pay_winnings(winnings)
    @money += winnings
  end

end
