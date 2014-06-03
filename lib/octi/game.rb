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
			run(@initial_position)
		end

		def run(position)
			if position.game_ended?
				ap winner(position.end_value)
			else
				ap "Your options ..."
				turn(@human, position)
				ap "Now it's my turn..."
				turn(@comp, position)
				ap position.pods
				run(position) 
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
			if position.game_ended?	
				ap "ENDED"				
			  return winner(position.end_value())#[nil, position.end_value()]	
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
				            best_move = new_move
				            best_value = move_value
				    end
				end
				return [best_move, best_value]
	        end
	    end	
		def turn(player, position)
			if player.index == 0
				val = bestmove(position,player,2)
				puts "res: #{val}"
			elsif player.index == 1
				options_prompt = get_options(position)
				move_choice = @ui.get_input(options_prompt.print_options) 
				final_choice = options_prompt.choose_key(move_choice.to_i, @ui)
				new_pos = final_choice.execute_move(position)
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
				ap "GAME OVER. You lost :("
			elsif value == -100
				ap "You won!"
			else
				ap "Error"
			end

		end
	end
end