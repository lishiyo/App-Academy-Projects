require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'player'
require 'colorize'

class Game
	
	attr_reader :players, :pot
	
	# initialize with any num of players and a new deck
	def initialize(*players)
		@players = players.select{ |p| p.bankroll > 0 }
		@deck = Deck.new
		@pot = 0
	end
	
	def current_winner
		players.max_by{ |p| p.bankroll }
	end
	
	def play
		puts "The players will be: #{players.map{|p| p.name}.join(", ")}.".colorize(:cyan)
		play_round until game_over?
	
		finish_game
	end

	def inspect
		"#{players.map{ |p| p.inspect }.join(", ")}"
	end
	 
	private

	def play_round 
		@pot = 0
		@deck = Deck.new
		@deck.shuffle
		# each player gets new hand
		renew_players
		# betting round begins to grow pot
		# end round and pay pot if everyone but one player folds
		puts "\nFIRST BETTING ROUND BEGINS\n".blue.blink
		take_all_bets
		return end_round if round_over?
		# allow each player to discard and get new cards from deck
		puts "\nDRAW PHASE BEGINS\n".blue.blink
		update_hands
		# second and last betting round if more than one still ing ame
		puts "\nSECOND BETTING ROUND BEGINS\n".blue.blink
		players.each do |p| 
			p.betted = false
			p.raised = false
		end
		take_all_bets 
		# show hands and pay pot
		end_round
	end

	def renew_players
		players.each do |player| 
			player.folded = false # reset players each round
			player.betted = false
			player.raised = false
			player.get_new_hand(@deck)
			@deck.shuffle
		end
	end
	
	# take bets until all active players have bet an equal amt
	# end entire round if everyone but one folds
	def take_all_bets
		no_raises = false
		player_seats = players.dup.select do |p| 
			p.bankroll > 0 && !p.folded?
		end.shuffle
		
		# first in player_seats bets
		curr_high_bet = get_opening_bet(player_seats)
		
		#A betting round ends when all active players have bet an equal amount or everyone folds to a player's bet or raise
		until no_raises
			no_raises = true
			player_seats = player_seats.rotate
		
			player_seats.each_with_index do |player, i| 
				next if player.folded?
				next if player.raised? || player.betted?
				puts "\nPlayer #{i+1}, #{player.name}'s turn. Current high bet: #{curr_high_bet}. Current pot: #{@pot}."
				move = player.get_move
				
				case move
				when :fold
					player.folded = true 
				when :see
					begin
						player.take_bet(curr_high_bet)
					rescue PokerError # move on to next player 
						puts "You cannot afford this bet.".red
						player.folded = true
					else
						puts "#{player.name}'s bankroll is now: #{player.bankroll}."
						@pot += curr_high_bet
						player.betted = true
					end
				when :raise
					begin
						raise PokerError if curr_high_bet > player.bankroll
						raise_bet = player.get_bet
						raise BadInputError unless raise_bet > curr_high_bet
					rescue BadInputError
						puts "You must raise higher than the current bet.".red
						retry 
					rescue PokerError
						puts "You cannot afford this bet.".red
						player.folded = true
					else # successful raise
						no_raises = false
						player.take_bet(raise_bet + curr_high_bet)
						puts "#{player.name}'s bankroll is now: #{player.bankroll}."
						curr_high_bet = raise_bet
						@pot += curr_high_bet
						player.raised = true
						# other players must now match raise
						player_seats.reject{|p| p == player}.each do |p|
							p.raised = false
							p.betted = false
						end
					end
				end
			end
			
			break if round_over?
		end
	end

	def get_opening_bet(player_seats)
		opening_better = player_seats.first
		puts "The opening better this round is: #{opening_better.name}.".colorize(:light_blue)
		
		bet = opening_better.get_bet
		
		if bet == 'fold'
			opening_better.folded = true
			remaining_players = player_seats - [opening_better]
			get_opening_bet(remaining_players)
		else # successful bet
			opening_better.betted = true
			opening_better.take_bet(bet)
			puts "#{opening_better.name}'s bankroll is now: #{opening_better.bankroll}."
			@pot += bet
			bet
		end
	end

	# Everyone but one has folded.
	def round_over? 
		players.one?{ |player| !player.folded? }
	end

	# each player can discard up to 3 cards and update their hands
	def update_hands
		players.each do |player|
			next if player.folded?
			discard_idx = player.get_discard
			player.update_hand(discard_idx, @deck)
		end
	end
	
	# If any players do not fold, players reveal their hands.
	# Strongest hand wins the pot.
	def end_round
		show_hands unless round_over? 
		remaining_hands = players.reject{ |p| p.folded? }
		.map{|p| p.hand }
		winner = Hand.highest_hand(remaining_hands)
		winner.take_winnings(@pot)
		
		puts "This round's winner is #{winner.name}, with a #{winner.hand.rank}.".colorize(:light_white).colorize(:background => :magenta)
		
	end
	
	def show_hands
		players.each_with_index do |player, i| 
			next if player.folded?
			player.hand.render
			puts "#{player.name}'s hand is a: #{player.hand.rank}."
		end
	end

	def game_over? # only one remaining or deck is empty
		players.one?{|p| p.bankroll > 0} || @deck.count.zero?
	end
	
	def finish_game
		winner = players.max_by{|p| p.net_winnings }
		puts "The winner is #{winner.name}, with $#{winner.net_winnings} in total winnings. CONGRATS!".colorize(:cyan)
		exit
	end

end


if __FILE__ == $PROGRAM_NAME
	p1 = Player.new("Connie", 1000)
	p2 = Player.new("Jack", 800)
	p3 = Player.new("Drea", 1200)
	p4 = Player.new("Max", 700)
	g = Game.new(p1, p2, p3, p4)
	g.play 
	
end