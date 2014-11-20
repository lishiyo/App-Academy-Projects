require './board.rb'
require './piece.rb'


class Game

	attr_reader :board, :current_player

	def initialize(player1, player2)
		@board = Board.new
		@players = {
			red: player1,
			black: player2
		}


		@current_player = :red
		@moves = 0
	end

	def play
		setup_players

		until board.won?(current_player)
			move_sequence = players[current_player].get_moves(board)
			board.perform_moves(move_sequence)
			@current_player = (current_player == :red) ? :black : :red
		end

		puts board.render
		puts "#{other_player} has won!"

		nil
	end

	private

	def other_player
		(current_player == :red) ? :black : :red
	end

	def setup_players
		@players[:red].color = :red
		@players[:black].color = :black
	end


end

class Player

	attr_accessor :color

end

class HumanPlayer

	def get_moves(board)
		puts board.render
		puts "Current player: #{color}"

		begin
			puts "Please enter your move sequence (EX: 9 18 27)."
			raw_input = gets.chomp.split

			unless raw_input.all?{|num| Integer(num).between?(1, 32) }
				raise CheckersError.new("Invalid input! Please use numbers 1-32.")
			end
		rescue => e
			puts e.message
			retry
		else
			translate_input(raw_input.map(&:to_i))
		end
	end

	private

	def translate_input(moves) #[9, 18, 27]
		moves = moves.map do |move|
			row = (move - 1) / 4
			multiple = (move - 1) % 4
			col = row.even? ? (2 * multiple) + 1 : (2 * multiple)
			[row, col]
		end

		moves
	end

end
