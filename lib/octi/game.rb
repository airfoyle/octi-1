module Octi
	class Game
		attr_reader :board_obj
		def initialize
			@ui = UserInterface.new
			@comp = Player.new(0)

			@human = Player.new(1)
			@board_obj = Board.new(6,7, @comp, @human)
			@initial_position = Position.new(@board_obj.board, @comp, @human)
			game_tree = GameTree.new(@initial_position)

			@ui.print_message("Welcome to OCTI!")
			run(@initial_position, @human)
		end

		def run(current_position, player_to_move)
			if current_position.game_ended?
				ap winner(current_position.end_value)
			else
				next_move = turn(player_to_move, current_position)
				#puts "move->#{next_move} ".colorize(:green)
				c_p = next_move.execute_move(current_position)
				current_position = c_p

				run(current_position, other_player(player_to_move)) 
			end
		end
		def other_player(player)
			if player.index == 0
				return @human
			else
				return @comp
			end
		end
		def bestmove(position, player, depth)
		#	puts "Entering bestmove[depth: #{depth}]".colorize(:blue)
			if position.game_ended?	
				puts "game over"
			  return [nil, position.end_value()]	
			elsif depth == 0
			  return [nil, position.heuristic_value(player)]
			else
				best_move = nil
				best_value = player.worst_value		
				moves = position.legal_moves(player).flatten
				for move in moves
				    new_move, move_value =
				    bestmove(move.execute_move(position),
				             other_player(player), #player.other_player
				             depth - 1)
				   
				    if player.better_for(move_value, best_value)
				            best_move = move#new_move
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
				plyr = DeepClone.clone player
				val = bestmove(position,plyr,2)
				puts val
				puts "plr prong: #{plyr.prong_reserve}"
				puts "I have chosen...".colorize(:yellow)
				puts "#{val[0].inspect}"
				return val[0]
			elsif player.index == 1
				puts "Your options ...".colorize(:yellow)
				options_prompt = get_options(position)
				move_choice = @ui.get_input(options_prompt.print_options) 
				final_choice = options_prompt.choose_key(move_choice.to_i, @ui)
				#new_pos = final_choice.execute_move(p)
				return final_choice#new_pos
			end
		end

		def get_options(position)
			all = position.legal_moves(@human)
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