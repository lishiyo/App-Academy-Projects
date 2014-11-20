require './board.rb'
require './piece.rb'


class Game

	attr_reader :board, :current_player
	
	def initialize

	end


end

class Player

	attr_accessor :color, :captured_pieces

	def initialize
		@captured_pieces = 0
	end


end
