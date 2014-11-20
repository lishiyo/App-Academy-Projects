require_relative 'piece'

class Board

	COLOR_ROWS = {
		:top => :red,
		:bottom => :black
	}

	attr_reader :grid, :size

	def initialize(fill_board = true, size = 8)
		@size = size
		create_grid(fill_board, size)
	end

	def [](pos)
		x, y = pos[0], pos[1]
		@grid[x][y]
	end

	def []=(pos, piece)
		x, y = pos[0], pos[1]
		@grid[x][y] = piece
	end

	def add_piece(piece, pos)
		raise CheckersError.new("Position not empty") unless empty?(pos)

		self[pos] = piece
	end

	def delete_piece(piece, pos)
		raise CheckersError.new("You don't have a piece there!") if empty?(pos)

		self[pos] = nil
	end

	def empty?(pos)
		self[pos].nil?
	end

	def self.in_bounds?(pos)
		pos.all?{|coord| coord.between?(0, 7) }
	end

	def dup
		duped_board = Board.new(false, self.size) # blank grid
		pieces.each do |piece| # instantiate new pieces with same pos and color
			piece.class.new(duped_board, piece.pos.dup, piece.color)
		end

		duped_board
	end

	def inspect
		@grid.each do |row|
			puts "#{ row.map{ |square| square.nil? ? square : square.color } }"
		end
	end

	protected

	def pieces
		@grid.flatten.compact
	end

	def create_grid(fill_board, size)
		@grid = Array.new(size) { Array.new(size) }
		return unless fill_board  # stop here unless place pieces
		# fill with red and black pieces


		@grid.each_with_index do |row, row_i|
			row.each_with_index do |col, col_j|
				fill_row = Proc.new do |color|
					@grid[row_i][col_j] = Piece.new(self, [row_i, col_j], color) if (row_i + col_j).odd?
				end

				fill_row.call(COLOR_ROWS[:top]) if row_i.between?(0, 2) # red pieces
				fill_row.call(COLOR_ROWS[:bottom]) if row_i.between?(5, 7) # black pieces
			end
		end

	end

end
