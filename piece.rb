require './board.rb'

class InvalidMoveError < StandardError
end

class Piece
	
	attr_accessor :pos, :color, :now_king
	attr_reader :board
	
	def initialize(board, pos, color)
		@now_king = false
		@board = board
		@pos = pos
		@color = color
		
		# put self on board
		@board[self.pos] = self
	end
	
	# one move diagonally
	def perform_slide(end_pos)
		deltas = move_diffs
		# both empty and in bounds
		valid_positions = deltas.map{ |(dx, dy)| [pos[0] + dx, pos[1] + dy] }
		.select{|pos| self.board[pos].nil? && Board.in_bounds?(pos) }
		
		puts "perform_slide valid pos: #{valid_positions}"
		raise InvalidMoveError.new("You can't slide there!") unless valid_positions.include?(end_pos)
		
		self.board[end_pos] = self # add self to new position on board
		self.board[pos] = nil # delete old position on board
		self.pos = end_pos # update self's pos
		
		@now_king = true if should_promote?
	end
	
	# should remove the jumped over piece from the Board
	def perform_jump(end_pos)
		deltas = move_diffs.map{ |x,y| [x * 2, y * 2] }
		posx, posy = pos[0], pos[1]
		# both empty and in bounds
		valid_positions = deltas.map{ |(dx, dy)| [posx + dx, posy + dy] }
		.select{|pos| board[pos].nil? && Board.in_bounds?(pos) }
		
		puts "perform_jump valid pos: #{valid_positions}, #{valid_positions.include?(end_pos)}, end_pos: #{end_pos}"
		
		raise InvalidMoveError.new("You can't jump there!") unless valid_positions.include?(end_pos)
		
		piece_between = board[[((posx + end_pos[0]) / 2), ((posy + end_pos[1]) / 2)]]
		raise InvalidMoveError.new("Can't jump over that place!") unless piece_between && piece_between.color != self.color
		
		#puts "perform_jump piece between: #{piece_between.pos}"

		# else, you can jump there
		self.board[end_pos] = self # add self to new position on board
		self.board[pos] = nil # delete old position on board
		self.pos = end_pos # update self's pos
		board[piece_between.pos] = nil # delete the enemy piece
		
		@now_king = true if should_promote?
	end
	
	# checks to see if piece has reached back row
	def should_promote?
		(self.color == :red) ? (board[pos] == 7) : (board[pos] == 1)
	end
	
	# First checks valid_move_seq?
	# either calls perform_moves! OR raises an InvalidMoveError
	def perform_moves(move_sequence)
		raise InvalidMoveError.new("That move sequence was invalid!") unless valid_move_seq?(move_sequence)
		
		perform_moves!
	end
	
	# 1) one slide, or 2) one or more jumps
	# If the sequence is one move long, try sliding; if that doesn't work, try jumping
	# If the sequence is multiple moves long, every move must be a jump.
	# Raise InvalidMoveError if a move in the sequence fails
	def perform_moves!(move_sequence)
		# move_sequence = [[2,1]] <- array of positions
	
		if move_sequence.size == 1 # one move, slide or jump
			end_pos = move_sequence.first
			p end_pos
			begin
				perform_slide(end_pos)
			rescue InvalidMoveError => e
				puts e.message
				perform_jump(end_pos) # raises error if invalid jump => valid_move_seq?
			end
		else # must all be jumps
			move_sequence.each { |end_pos| perform_jump(end_pos) }
		end
		
	end
	
	# calls perform_moves! on a *duped* Piece/Board
	# returns true only if no error is raised
	def valid_move_seq?(move_sequence)
		begin
			duped_board = board.dup
			duped_piece = duped_board[self.pos] # doppleganger on duped_board
			duped_piece.perform_moves!(move_sequence)
		rescue InvalidMoveError
			return false
		end
		
		true
	end
	
	def inspect
		"#{@color}#{@now_king}#{pos}"
	end
	
	private
	
	def move_diffs
		deltas = { red: [[1, 1], [1, -1]], black: [[-1, 1], [-1, -1]] }
		
		return deltas[self.color] unless @now_king
		
		# if king, return both
		deltas[:red] + deltas[:black]
	end
end