module Octi
	class GameTree
		attr_reader :pod
		def initialize(board_position)

		end

		# def generate
		# 	initial_game_state = GameState.new(@comp = Player.new(0),@human = Player.new(1), @board = Board.new(6,7))			
		# end


### MINIMAX ALGO ###
 		def bestmove(position, player, depth)
			if position.game_ended?					
			  return [nil, position.end_value()]	
			elsif depth == 0
			  return [nil, position.heuristic_value(player)]
			else
				best_move = nil
				best_value = Player.worst_value		
				moves = position.legal_moves(player)
				for move in moves
				    new_move, move_value =
				    bestmove(move.execute_move(position),
				             player.other_player,
				             depth - 1)
				    if player.better_for(move_value, best_value)
				            best_move = new_move
				            best_value = move_value
				    end
				end
				return [best_move, best_value]
	        end
	    end	
	end
end