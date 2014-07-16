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

			@ui.print_message("Welcome to OCTI!")
			run(@initial_position, @human)
		end

		def run(current_position, player_to_move)
			if current_position.game_ended?(player_to_move)
				ap winner(current_position.end_value(player_to_move))
			else
				next_move = turn(player_to_move, current_position)
				#puts "move->#{next_move} ".colorize(:green)
				c_p = next_move.execute_move(current_position)
				current_position = c_p

				run(current_position, current_position.other_player(player_to_move)) 
			end
		end
		
		def bestmove(position, player, depth)
			#puts "Entering bestmove[depth: #{depth}]".colorize(:blue)
			#debugger
			if position.game_ended?(player)	

				puts "game over depth:#{depth}".colorize(:green)
			  return [nil, position.end_value(player)]	
			elsif depth == 0
				#debugger
			  return [nil, position.heuristic_value(player)]
			else
				best_move = nil
				best_value = player.worst_value		
				moves = position.legal_moves(player).flatten
				for move in moves
				    new_move, move_value =
				    bestmove(move.execute_move(position),
				             position.other_player(player), 
				             depth - 1)
				  # debugger
				    if player.better_for(move_value, best_value)
				            best_move = move
				            best_value = move_value
				    end
				end
				return print_bestmove(best_move, best_value, depth)
	        end
	    end	
	    def print_bestmove(m, v, d)
	    	#puts "Exiting bestmove[depth= #{d}]|best_move= #{m}|best_value= #{v}".colorize(:blue)
	    	return [m,v]
	    end

		def turn(player, position)
			if player.index == 0
				puts "Now it's my turn...".colorize(:yellow)
				#plyr = DeepClone.clone player
				val = bestmove(position,player,2)
				#puts "bestmove returned-> #{val}"
				puts "I have chosen...".colorize(:yellow)
				puts "[#{val[0]},#{val[1].inspect}]"
				return val[0]
			elsif player.index == 1
				puts "Your options ...".colorize(:yellow)
				options_prompt = get_options(position, player)

				#get player's move choice
					#add quit feature and loop
				move_choice = @ui.get_input(options_prompt.print_options) 
				final_choice = options_prompt.choose_key(move_choice.to_i, @ui)
				
				return final_choice
			end
		end

		def get_options(position, player)
			all = position.legal_moves(player)
			
			#return options
			oh = OptionHash.new(all)

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