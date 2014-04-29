module Octi
	class GameTree

		attr_accessor :comp, :human

		def generate
			initial_game_state = GameState.new(comp,human, @board = Board.new(6,7))
			generate_moves(initial_game_state)
			initial_game_state
		end


	end
end