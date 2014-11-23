require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'player'
require 'colorize'

class Game
	
	attr_reader :players, :pot
	
	# initialize with any num of players and a new deck
	def initialize(*players)
		@players = players
		@deck = Deck.create_deck # array of 52 cards
		@pot = 0
	end
	
	def current_winner
		players.max_by{ |p| p.bankroll }
	end
	
	def play
		puts "The players will be: #{players.map{|p| p.name}.join(", ")}."
		play_round until game_over?
	
		finish_game
	end

# 	def add_players(*players)
# 		@players += players
# 	end

	def inspect
		"#{players.map{ |p| p.inspect }.join(", ")}"
	end
	 
	private

	def play_round 
		@pot = 0
		# each player gets new hand
		@deck = @deck.shuffle
		players.each do |player| 
			player.folded = false # reset players each round
			player.get_new_hand(@deck)
		end
		# betting round begins to grow pot
		# end round and pay winnings if everyone but one player folds
		take_all_bets
		return end_round if round_over?
		# allow each player to discard and get new cards from deck
		update_hands 
		# second and last betting round
		take_all_bets 
		# show hands
		end_round
	end
	
	# take bets that add to round's pot until no one raises
	# end entire round if everyone but one folds
	def take_all_bets
		no_raises = false
		player_seats = players.dup.select{ |p| p.bankroll > 0 }.shuffle
		
		opening_better = player_seats.first
		curr_high_bet = get_opening_bet(opening_better)
		
		until no_raises
			no_raises = true
			player_seats = player_seats.rotate # rotate each round
		
			player_seats.each_with_index do |player, i| 
				next if player.folded?
				next if player.raised? || player.betted?
				puts "\nPlayer #{i+1}, #{player.name}'s turn. Current bet: #{curr_high_bet}."
				move = player.get_move
				
				case move
				when :fold
					player.folded = true 
				when :see
					begin
						player.take_bet(curr_high_bet)
					rescue PokerError # move on to next player 
						puts "You cannot place a bet greater than your bankroll."
					else
						puts "#{player.name}'s bankroll is now: #{player.bankroll}."
						@pot += curr_high_bet
						betted_player = player
					end
				when :raise
					begin
						raise_bet = player.get_bet
						raise BadInputError unless raise_bet > curr_high_bet
						raise PokerError if raise_bet > player.bankroll
					rescue BadInputError
						puts "You must raise higher than the current bet."
						retry 
					rescue PokerError
						puts "You cannot afford this bet."
					else
						curr_high_bet = raise_bet
						player.take_bet(curr_high_bet)
						@pot += curr_high_bet
						player.raised = true
						no_raises = false
					end
				end
			end
			
			break if round_over?
		end
	end

	def get_opening_bet(opening_better)
		puts "The opening better this round is: #{opening_better.name}."
		begin
			bet = opening_better.get_bet
			raise PokerError if bet == 'quit'
		rescue
			puts "You must make a bet as the opening better!"
			retry
		end
		
		bet
	end

	# Everyone but one has folded.
	def round_over? 
		players.one?{ |player| !player.folded? }
	end

	# each player can discard up to 3 cards and update their hands
	def update_hands
		players.each do |player|
			discard_idx = player.get_discard
			player.update_hand(discard_idx, @deck)
		end
	end
	
	# If any players do not fold, players reveal their hands.
	# Strongest hand wins the pot.
	def end_round
		show_hands unless round_over? 
		remaining = players.reject{ |p| p.folded? }
		winner = get_winner(remaining)
		puts "This round's winner is #{winner.name}, with a #{winner.hand.rank}."
		
		winner.take_winnings(@pot)
	end

	def get_winner(players)
		players.max_by { |p| p.hand }
	end
	
	def show_hands
		players.each_with_index do |player, i| 
			puts "#{player.name}'s hand: #{player.hand.render}."
		end
	end

def game_over? # only one remaining or deck is empty
		players.one?{|p| p.bankroll > 0} || @deck.empty?
	end
	
	def finish_game
		winner = players.max_by{|p| p.net_winnings }
		puts "The winner is #{winner.name}, with $#{winner.net_winnings} in total winnings. CONGRATS!"
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