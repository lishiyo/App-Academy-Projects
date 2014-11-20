require './piece.rb'

class Board
	
	attr_reader :grid
	
	def initialize(fill_board = true)
		create_grid(fill_board)
	end
	
	def [](pos)
		x, y = pos[0], pos[1]
		@grid[x][y]
	end
	
	def []=(pos, mark)
		x, y = pos[0], pos[1]
		@grid[x][y] = mark
	end
	
	def self.in_bounds?(pos)
		pos.all?{|coord| coord.between?(0, 7) }
	end
	
	def dup
		duped_board = Board.new(false) # blank grid
		pieces.each do |piece| # instantiate new pieces with same pos and color
			piece.class.new(duped_board, piece.pos, piece.color)
		end
		
		duped_board
	end
	
	def inspect
		grid = @grid.map{|row| row.map{|square| square.nil? ? square : square.color } }
		
		grid.join("\n")
	end
	
	protected
	
	def pieces
		@grid.flatten.compact
	end
	
	def create_grid(fill_board)
		@grid = Array.new(8) { Array.new(8) } # stop here unless place pieces
		return unless fill_board
		# fill with red and black pieces
		@grid.each_with_index do |row, row_i|
			row.each_with_index do |col, col_j|
				if row_i.between?(0, 2) # red pieces
						@grid[row_i][col_j] = Piece.new(self, [row_i, col_j], :red) if (row_i + col_j).odd?
				elsif row_i.between?(5, 7) # black pieces
					@grid[row_i][col_j] = Piece.new(self, [row_i, col_j], :black) if (row_i + col_j).odd?
				end
			end
		end
		
	end
	
end