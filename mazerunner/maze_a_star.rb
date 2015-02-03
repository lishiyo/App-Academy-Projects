#!/usr/bin/env ruby
# http://gabrielgambetta.com/path2.html
# http://rubyquiz.com/quiz98.html


# SETUP

class Node
	attr_accessor :coords, :cost, :previous, :value
  def initialize(coords)
    @coords = coords
		# set at infinity except for start node
    @cost = Float::INFINITY
  end
	
	def ==(other_node)
		self.coords == other_node.coords
  end
end

# CONVERT arr into NODE objects
class MazeRunner
	
	attr_reader :start_node, :goal_node
	
	def self.create_nodes_arr(arr)
		arr.map.with_index do |line, x|
			line.map.with_index do |point, y|
				node = Node.new([x,y])
				node.value = point
				if point == "S"
					node.cost = 0
					node.previous = nil
				end
				node
			end
		end
	end

	def initialize(arr)
		maze = self.class.create_nodes_arr(arr)
		@nodes_arr = maze.flatten.sort_by{|node| node.coords}
		@start_node = find_target_nodes.first
		@goal_node = find_target_nodes.last
	end	

	# MAIN SOLUTION

	# Choose an open node and see what new nodes we can reach 
	# Keep looking until we reach the goal node or we run out of nodes to look at (no path)
	def find_path

		# INITIALIZE
		valid = valid_nodes(@nodes_arr)
		reachable = [@start_node] # nodes we can reach from current node
		explored = [] # closed nodes
		# nodes reachable, valid, and not explored
		open_nodes = (valid - explored) & reachable
		node = nil

		while !open_nodes.empty?

			node = choose_node_in(open_nodes) # least total cost node

			# STOP if reached goal
			return build_path if node == @goal_node 

			# Don't repeat ourselves.
			reachable.delete(node) # remove curr node from reachable
			explored.push(node) # add curr node to explored

			# What nodes are now open from this node?
			# Adjacent, not explored, and valid (not an obstacle and in maze)
			new_reachable = (get_adjacent_nodes(node) - explored) & valid

			# ADD new adjacent nodes to reachable
			new_reachable.each do |adj_node|
				if !reachable.include?(adj_node)
					reachable << adj_node 
				end

				# if this is a new path (adj_node.cost==infinity) or a shorter distance from start than before, save this path
				if adj_node.cost > (node.cost + 1)
					adj_node.previous = node # reset current node as parent
					adj_node.cost = (node.cost + 1) # reset minimum cost
				end

			end

			# REFRESH OPEN NODES
			open_nodes = (valid - explored) & reachable

		end

		nil # open_nodes empty - no path found
	end
	
	private
	
	# UTLITY METHODS

	# return manhattan distance estimate: abs(Ax - Bx) + abs(Ay - By))
	def estimate_distance(start_node, dest_node)
		arr = start_node.coords.zip(dest_node.coords) # [[Ax, Bx], [Ay, By]]

		arr.reduce(0){|sum, pair| sum += (pair[1]-pair[0]).abs; sum }
	end

	# return the node in open nodes with the lowest total cost F
	def choose_node_in(open_nodes)
		min_cost = Float::INFINITY
		best_node = nil

		open_nodes.each do |node|
			cost_start_to_node = node.cost # G
			cost_node_to_goal = estimate_distance(node, @goal_node) # H
			# F = G + H
			total_cost = cost_start_to_node + cost_node_to_goal

			# find the lowest total cost in open_nodes
			if total_cost < min_cost
				min_cost = total_cost
				best_node = node
			end
		end

		best_node
	end

	# returns all four nodes within 1 step
	def get_adjacent_nodes(center_node)
		@nodes_arr.select {|node| estimate_distance(node, center_node) == 1 } 
	end

	def build_path(node = @goal_node)
		path = []
		until node.previous.nil? # keep adding until hit start node
			node = node.previous
			break if node.previous.nil? # don't add start node to path
			path << node
		end

		#return path.reverse.map{|node| node.coords}
		print_out(path)
	end

	# PRINT OUT SOLUTION
	def print_out(path)
		maze = @nodes_arr.each { |node| node.value = "X" if path.include?(node)}.map{|node| node.value }.join

		puts maze
		File.open("maze_a_star_sln.txt", "w"){ |f| f.puts "#{maze}"}
	end

	def find_target_nodes
		start_node = @nodes_arr.select{|node| node.value == "S"}.first
		goal_node = @nodes_arr.select{|node| node.value == "E"}.first

		[start_node, goal_node]
	end

	# DEFINE set of nodes in maze array and not an obstacle
	def valid_nodes(arr)
		arr.select{|node| node.value == " " || node.value == "S" || node.value == "E"}
	end


end

if __FILE__ == $PROGRAM_NAME
	# READ IN MAZE
	f = File.open("maze1.txt") # 8 x 17 array
	arr = f.readlines.map{|line| line.chars }
	maze = MazeRunner.new(arr)
	maze.find_path
end