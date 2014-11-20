require_relative 'board'
require_relative 'piece'

class Game

	attr_reader :board, :current_color, :players

	def initialize(player1 = HumanPlayer.new, player2 = HumanPlayer.new)
		@board = Board.new
		@players = {
			red: player1,
			black: player2
		}

		@current_color = :red
		@moves = 0
	end

	def play
		setup_players

		until board.won?(current_color)
			begin
				move_sequence = players[current_color].get_moves(board)
				start_piece = board[move_sequence.shift]

				if start_piece.nil? || start_piece.color != current_color
					raise CheckersError.new("Invalid starting piece")
				end
				start_piece.perform_moves(move_sequence)

			rescue CheckersError => e # catch human errors
				players[current_color].handle_move_response(e)
				retry
			end

			@current_color = (current_color == :red) ? :black : :red
		end

		puts board.render
		puts "#{current_color.to_s.upcase} wins!"

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

class HumanPlayer < Player

	def get_moves(board)
		board.render
		puts "Current player: #{color}"

		begin
			puts "Please enter your move sequence (EX: 9 18 27)."
			raw_input = gets.chomp.split

			unless raw_input.all?{|num| Integer(num).between?(1, 32) }
				raise CheckersError.new("Invalid move sequence. Please use numbers 1-32.")
			end
		rescue => e
			puts e.message
			retry
		else
			translate_input(raw_input.map(&:to_i))
		end
	end

	def handle_move_response(e)
		puts e.message
	end

	private

	def translate_input(moves) #[9, 18, 27]
		moves.map! do |move|
			row = (move - 1) / 4
			multiple = (move - 1) % 4
			col = row.even? ? (2 * multiple) + 1 : (2 * multiple)
			[row, col]
		end
	end

end

class ComputerPlayer < Player

end
