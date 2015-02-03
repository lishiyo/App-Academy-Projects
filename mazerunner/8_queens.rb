# N = 8, board = 8x8 array
# Generate positions where queens are safe
# Randomly place queens ([row, col]) on board with constraint that no queen is on the same row or diagonal

# Every time you add a queen to the BOARD, its row, column, and diagonal become unsafe

BOARD = (1..8).to_a.reverse.map{|row_n| (1..8).to_a.map{|col_n| [row_n, col_n]}}.flatten(1)

# UPDATE THE UNSAFE board given QUEENS array
def refresh_board(queens)
	unsafe = []
	queens.each do |queen| 
		qx, qy = queen[0], queen[1]
		BOARD.each do |point|
			x, y = point[0], point[1]
			if x == qx || y == qy || (x+y)==(qx+qy) # same row or column, or diagonal
				unsafe << [x,y] unless [x,y]==[qx, qy] # queen's own point is safe
			end
		end
	end
	
	return unsafe.uniq
end

def start_queens( n = 8 )
	
	# INIT EMPTY BOARDS
	unsafe = []
	safe = (BOARD - unsafe)
	queens = []
	last_queens = []
	
	until queens.length == n && queens.all?{|queen| safe?(queen, safe)}
		break if queens.length == n && queens.all?{|queen| safe?(queen, safe)} # break out of immediately
		
		if queens.length < n && (safe - queens).empty? # no safe spots left on board
			until ((safe - queens - last_queens).size > (n - queens.size))
				last_queens << queens.pop # remove last queen
				unsafe = refresh_board(queens)
				safe = (BOARD - unsafe)
			end
		elsif !(safe - queens).empty? 
			point = (safe - queens).sample # random point from safe
			if safe?(point, safe)
				queens << point
				unsafe = refresh_board(queens)
				safe = (BOARD - unsafe)
			end
		end
		
	end # UNTIL
	
	p queens
	print_out(queens)
end

def queens( n = 8 )
	
	# INIT BOARDS
	queens = BOARD.sample(8)
	unsafe = refresh_board(queens)
	safe = (BOARD - unsafe)
	
	until queens.all?{|queen| safe?(queen, safe) }
		
		if safe?(queen.last, safe)
			queens << point
			# unsafe = add_queen_to(unsafe, point)
			unsafe = refresh_board(queens)
			safe = (BOARD - unsafe)
		elsif queens.length < n && safe.empty? # no safe spots left on board
			until !safe.empty?
				queens = queens[0..-2] # remove last queen
				unsafe = refresh_board(queens)
				safe = (BOARD - unsafe)
			end
			
		end
		
	end # WHILE
	
	
end

def safe?(point, curr_safe)
	curr_safe.include?(point)
end

def print_out(queens, n = 8)
	
	board = ""
	
	(1..n).each do |row|
		(1..n).each do |col| 
			point = [row, col]
			queens.include?(point) ? board += " Q " : board += " * "
		end
		board += "\n" # end the row
	end
	
	File.open("8_queens_v1.txt", "w"){ |f| f.puts "#{board}"}
end

start_queens
