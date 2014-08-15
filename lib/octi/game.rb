module Octi
	class Game
		attr_reader :board_obj
		def initialize
			@ui = UserInterface.new
			@comp = Player.new(0, 32)

			@human = Player.new(1, 32)
			@board_obj = Board.new(6,7, @comp, @human)
			@initial_position = Position.new(@board_obj.board, @comp, @human)
			game_tree = GameTree.new(@initial_position)
			@moves_made = Array.new(2) { Array.new() }

			@ui.print_message("Welcome to OCTI!")
			run(@initial_position, @human)
		end

		def run(current_position, player_to_move)
			if current_position.game_ended?(player_to_move)
				ap winner(current_position.end_value(player_to_move))
			else
				next_move = turn(player_to_move, current_position)
				@moves_made[player_to_move.index].push(next_move)
				#puts "move->#{next_move} ".colorize(:green)

				c_p = next_move.execute_move(current_position)
				current_position = c_p

				run(current_position, current_position.other_player(player_to_move)) 
			end
		end
		
		def bestmove(position, player, depth)
			#puts "Entering bestmove[depth: #{depth}]".colorize(:blue)
			if position.game_ended?(player)	

				puts "G_O:depth:#{depth}, p:#{player.index}, #{position.end_value(player)}, #{position.heuristic_value(player)}".colorize(:green)
			  return nil, position.end_value(player)	
			elsif depth == 0
			puts "end of tree 0"
			  return nil, position.heuristic_value(player)
			else
				best_move = nil
				best_value = player.worst_value		
				moves = position.legal_moves(player).flatten
				for move in moves
				    new_move, move_value = bestmove(move.execute_move(position),
				             position.other_player(player), 
				             depth - 1)
				    if player.better_for(move_value, best_value)
				    	puts "BM: #{new_move}"
				            best_move = new_move
				            best_value = move_value
				    end
				end
				return print_bestmove(best_move, best_value, depth, player,position)
	        end
	    end	
	    def print_bestmove(m, v, d, p,position)
	 
	   		position.game_ended?(p)

	    	#puts "Exiting bestmove[depth= #{d}]|Player: #{p.index}| best_move=#{m.class}| Pod:(#{m.origin.x}, #{m.origin.y})|best_value= #{v}".colorize(:blue)
	    	puts "exiting bestmove: m #{m}, v #{v}"
	    	if m.class == Insert && p.index == 1
	    		 
	    		puts "Insert details: (#{m.x}, #{m.y})".colorize(:yellow)
	    	end
	    	
	    	return m,v
	    end

		def turn(player, position)
			if player.index == 0
				puts "Now it's my turn...".colorize(:yellow)
				val = bestmove(position,player,2)
				puts "I have chosen...".colorize(:yellow)

				print_move(val[0])

				return val[0]
			elsif player.index == 1
				puts "Your options ...".colorize(:yellow)
				options_prompt = get_options(position, player)
				move_choice = @ui.get_input(options_prompt.print_options) 
				while !(1..3).include?(move_choice.to_i)
					puts "Please Choose a valid option.".colorize(:red)
					move_choice = @ui.get_input(options_prompt.print_options) 
				end
				final_choice = options_prompt.choose_key(move_choice.to_i, @ui)
				
				return final_choice
			end
		end

		def print_move(move)
			if move.class == Insert
					puts "Move: #{move.class}| Pod Location:(#{move.origin.x}, #{move.origin.y}) | Insert prong at: (#{move.x}, #{move.y})" #color?
			elsif move.class == Hop
				puts "Move: #{move.class}|Pod Location:(#{move.origin.x}, #{move.origin.y}) | Pod Destination: (#{move.destination.x}, #{move.destination.y})" 
			elsif move.class == Jump
				puts "Move: #{move.class}|Pod Location:(#{move.origin.x}, #{move.origin.y}) | Pod Destination: (#{move.destination.x}, #{move.destination.y})|captures: #{move.jumped_pods}"
			else
				puts "ERROR: Move is nil: #{move}".colorize(:red)
			end
		end

		def all_moves(index)
			for move in @moves_made[index]
				print_move(move)
			end
			
		end
		def get_options(position, player)
			all = position.legal_moves(player)
			
			#return options
			oh = OptionHash.new(all, player)

			return oh
		end

		def winner(value)
			if value == 100
				puts "GAME OVER. You lost :(".colorize(:red)
			elsif value == -100
				puts "You won!".colorize(:green)
			else
				puts "Error".colorize(:red)
			end

		end
	end
end