module Octi
	class GameTree

		attr_accessor :comp, :human, :positions, :comp_pos, :board, :inserts
		
		def initialize
		end

		def generate
			initial_game_state = GameState.new(comp,human, @board = Board.new(6,7))
			generate_moves(initial_game_state)
			initial_game_state
		end

		def generate_moves(game_state)
			hops = Array.new #array of Hop objects
			inserts=nil
			jumps = []
			
			for position in game_state.board.comp.positions
				#if pod can move, make move?
				insert_move = Insert.new.make(game_state, position)
				hope_move = Hop.new.make(game_state, position)
				jump_move = Jump.new.make(game_state.board, position)
			end
			puts game_state.moves

		end
	end
end

