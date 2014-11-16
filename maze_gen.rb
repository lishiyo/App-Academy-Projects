#!/usr/bin/env ruby
# http://gabrielgambetta.com/path1.html
# http://rubyquiz.com/quiz98.html

# READ IN MAZE
f = File.open('maze1.txt') #8 x 17 array
arr = f.readlines.map{|line| line.chars }

COORDS_HASH = {}

# CONVERT arr into coordinates and a coordinates hash
def coords_arr(arr)
	arr.map.with_index do |line, x|
		line.map.with_index do |point, y|
			COORDS_HASH[[x,y]] = point
			[x,y]
		end
	end
end

def find_target_nodes(arr)
	start_node, goal_node = [], []
	arr.each_with_index do |line, y|
		if line.include?("S")
			start_node = [y, line.index("S")] # [6,1]
		elsif line.include?("E")
			goal_node = [y, line.index("E")] # [1,14]
		end
	end
	return start_node, goal_node
end

# DEFINE set of nodes in maze array and not an obstacle
def valid_nodes
	COORDS_HASH.select{|k, v| v == " " || v == "S" || v == "E"}.keys
end

# UTLITY METHODS
# returns all four nodes within 1 step by x and y
def get_adjacent_nodes(node) #[[6,1]]
	adj = []
	node = [node]
	node.each do |node|
		x, y = node[0], node[1]
		adj = [[(x+1),y], [(x-1), y], [x, (y+1)], [x, (y-1)]]
	end
	adj
end

def build_path(goal_node, nodes_path)
	path = [goal_node]
	node = get_previous_node(path.last, nodes_path)

	while node
    node = get_previous_node(path.last, nodes_path)
		break if node.nil?
    path << node
  end

	print_out(path)
end

def get_previous_node(node, nodes_path)
  return nil if nodes_path[node].nil? # found start_node
  return nodes_path[node]
end

# PRINT OUT SOLUTION TO NEW FILE
def print_out(path)
	
	# add X's for path
	path.each do |coord|
		COORDS_HASH[coord] = "X" unless (COORDS_HASH[coord]=="S" || COORDS_HASH[coord]=="E")
	end
	
	maze = COORDS_HASH.values.join
	
	File.open("maze_gen_sln.txt", "w"){ |somefile| somefile.puts "#{maze}"}
end

# MAIN

# SET COORDS, START AND GOAL NODES
COORDS = coords_arr(arr)
START_NODE = find_target_nodes(arr).first # [6,1]
GOAL_NODE = find_target_nodes(arr).last # [1,14]

# Choose an open node and see what new nodes we can reach 
# Keep looking until we reach the goal node or we run out of nodes to look at (no path)
def path_finder(start_node=START_NODE, goal_node=GOAL_NODE)
	
	# INITIALIZE
	valid = valid_nodes # largest set
	reachable = [start_node] # nodes we can reach from current node
	explored = [] # nodes we've already considered
	# nodes reachable, valid, and not explored
	open_nodes = valid.select{|node| reachable.include?(node)}.select{|node| !explored.include?(node)} 
	# record node path {node => previous_node}
	nodes_path = {start_node => nil} 
	
	while !open_nodes.empty?
   # node = choose_node(reachable)
		node = open_nodes.sample # random node in open_nodes
		
		return build_path(goal_node, nodes_path) if node==goal_node # STOP if reached goal! 
   
    # Don't repeat ourselves.
    reachable.delete(node) # remove current node from reachable
    explored.push(node) # add node to explored
   
    # What nodes are now open from this node?
    # Adjacent, not in explored, and valid (not an obstacle and in maze)
    new_reachable = (get_adjacent_nodes(node) - explored) & valid
		# ADD new nodes to reachable
    new_reachable.each do |adj_node|
      if !reachable.include?(adj_node)
        # adjacent.previous = node  # Remember how we got there.
        nodes_path[adj_node] = node # {[0,3] => [0,2]}
        reachable << adj_node
      end
    end
    
		# REFRESH OPEN NODES
    open_nodes = valid.select{|node| reachable.include?(node)}.select{|node| !explored.include?(node)} 
    
  end
  
	return nil # open_nodes empty - no path found
end

if __FILE__ == $PROGRAM_NAME
     path_finder
end


