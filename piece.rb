require_relative 'board'

class CheckersError < StandardError
end

class InvalidMoveError < CheckersError
end

class InvalidSlideError < InvalidMoveError
end

class InvalidJumpError < InvalidMoveError
end


class Piece

	attr_accessor :pos, :color, :now_king
	attr_reader :board

	def initialize(board, pos, color)
		@now_king = false
		@board, @pos, @color = board, pos, color

		# put self on board
		board.add_piece(self, pos)
	end

	# one move diagonally
	def perform_slide(end_pos)
		valid_positions = get_valid_pos(move_diffs)
		return false unless valid_positions.include?(end_pos)

		move_piece(end_pos)

		true
	end

	# should remove the jumped over piece from the Board
	def perform_jump(end_pos)
		deltas = move_diffs.map{ |x,y| [x * 2, y * 2] }
		valid_positions = get_valid_pos(deltas)
		return false unless valid_positions.include?(end_pos)

		piece_between = board[[((pos[0] + end_pos[0]) / 2), ((pos[1] + end_pos[1]) / 2)]]
		return false unless piece_between && piece_between.color != self.color

		move_piece(end_pos)
		board.delete_piece(piece_between, piece_between.pos) # capture the enemy piece

		true
	end

	# First checks valid_move_seq?
	# either calls perform_moves! OR raises an InvalidMoveError
	def perform_moves(*move_sequence)
		raise InvalidMoveError.new("That move sequence was invalid!") unless valid_move_seq?(*move_sequence)

		perform_moves!(*move_sequence)
	end

	# 1) one slide, or 2) one+ jumps
	# If the sequence is one move long, try sliding; if that doesn't work, try jumping
	# If the sequence is multiple moves long, every move must be a jump.
	# Raise InvalidMoveError if a move in the sequence fails.
	def perform_moves!(*move_sequence)
		# *move_sequence = [2,1], [3,2] => array of positions

		if move_sequence.size == 1 # one move, slide or jump
			end_pos = move_sequence.first
			begin
				raise InvalidMoveError unless perform_slide(end_pos) || perform_jump(end_pos)
				perform_slide(end_pos) ? perform_slide(end_pos) : perform_jump(end_pos)
			rescue InvalidSlideError
				perform_jump(end_pos)
			rescue InvalidMoveError => e
				puts e.message
			end
		else # must all be jumps
			move_sequence.each { |end_pos| perform_jump(end_pos) }
		end

	end

	# calls perform_moves! on a *duped* Piece/Board
	# returns true only if no error is raised
	def valid_move_seq?(*move_sequence)
		begin
			duped_board = board.dup
			duped_piece = duped_board[self.pos] # doppleganger on duped_board
			duped_piece.perform_moves!(*move_sequence)
		rescue InvalidMoveError
			return false
		end

		true
	end

	def inspect
		"#{@color}#{@now_king}#{pos}"
	end

	# unicode checkers
	def render

	end

	private

	def move_piece(end_pos)
		board.add_piece(self, end_pos) # add self to new position on board
		board.delete_piece(self, pos) # delete old position on board
		self.pos = end_pos # update self's internal pos

		self.now_king = true if should_promote?
	end

	def get_valid_pos(deltas)
		posx, posy = pos[0], pos[1]
		# both empty and in bounds
		deltas.map{ |(dx, dy)| [posx + dx, posy + dy] }
			.select{|pos| self.board[pos].nil? && Board.in_bounds?(pos) }
	end

	# checks to see if piece has reached back row
	def should_promote?
		row = pos[0]
		(self.color == :red) ? (row == 7) : (row == 0)
	end

	def move_diffs
		deltas = { red: [[1, 1], [1, -1]], black: [[-1, 1], [-1, -1]] }

		# if king, return both
		now_king ? (deltas[:red] + deltas[:black]) : deltas[self.color]
	end


end
