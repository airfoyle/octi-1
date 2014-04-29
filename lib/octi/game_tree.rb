module Octi
	class GameTree

		attr_accessor :comp, :human

		def generate
			initial_game_state = GameState.new(comp,human, @board = Board.new(6,7))
			generate_moves(initial_game_state)
			initial_game_state
		end

		def generate_moves(game_state)

			for each position in game_state.comp_pos
				#if pod can move, make move?
				move = Move.new(board, position)
				move.can_move?(board, move.x, move.y)
			end
		end
	end
end