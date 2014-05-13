module Octi
	class GameTree

		attr_accessor :comp, :human, :positions, :comp_pos, :board, :inserts,:pod
		
		def initialize
		end

		def generate
			initial_game_state = GameState.new(@comp = Player.new(0),@human = Player.new(1), @board = Board.new(6,7))			
		end


### MINIMAX ALGO ###
=begin
		def minimax (position)
			return maxmove(position)
		end

		def maxmove (position)
			if (game_ended?(position))
				return eval_game_state(position)
			else
				best_move = {}
				moves = position.legal_moves(@comp)
				for move in moves
					move = minmove()
				end
			end

		end

=end					
	end
end

