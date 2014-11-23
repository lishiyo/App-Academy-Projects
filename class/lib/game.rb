require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'player'

class Game

  def initialize(num_players = 3)
    @deck
    @pot
    @curr_player
  end

  # generate new deck, deals cards
  def play
  end

end
