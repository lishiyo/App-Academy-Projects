# http://rosettacode.org/wiki/N-queens_problem#Ruby
# n-queens heuristic for any N >= 4 from Wikipedia
# generates list of numbers for vertical positions (rows) with horizontal position (col) from 1..N

class NQueens
	
	def initialize(n)
		@rows = []
		place_queens(n)
	end
	
	def place_queens(n)
		
		# If the remainder from dividing N by 6 is not 2 or 3 then the list is all even numbers followed by all odd numbers ≤ N
		if (n % 6 != 2) && (n % 6 != 3)
			@rows = (1..n).partition{|i| i.even?}.flatten
		else
		# write separate lists of even and odd numbers 
			even = (1..n).partition{|i| i.even?}.first
			odd = (1..n).partition{|i| i.even?}.last

			if n % 6 == 2
				odd[0], odd[1] = odd[1], odd[0]
				odd = odd.insert(odd.length-1, odd.delete_at(odd.index(5)))
			elsif n % 6 == 3
				even = even.insert(even.length-1, even.delete_at(even.index(2)))
				odd = odd.push(odd.shift(2)).flatten
			end

			@rows = even.concat(odd)
		end

	end

	def render
		queens = @rows.map.with_index{|row, i| [row, i+1]}
		n = @rows.length
		board = ""
		(1..n).each do |row|
			(1..n).each do |col| 
				point = [row, col]
				queens.include?(point) ? board += " Q " : board += " * "
			end
			board += "\n" # end the row
		end

		# reads out to bash
		puts board
		
		# saves to file
		File.open("n_queens_h.txt", "w"){ |f| f.puts "#{board}"}
	end

end


if __FILE__ == $PROGRAM_NAME
	puts "how many queens?"
	n = Integer(gets.chomp)
	nqueens = NQueens.new(n)
	nqueens.render
end
	