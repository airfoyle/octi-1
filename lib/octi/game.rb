module Octi
	class Game
		def initialize
			@game_state = @initial_game_state = GameTree.new.generate
		end
	end

	def turn
		if @game_state.final_state?
		 	describe_final_game_state
		end
		if @game_state.current_player == 
		  	turn
		else
		 	get_human_move
		 	turn
		end
 	end
end

=begin
#TODO
	*minimax alg
	*fix move class to "describe" moves
	*create an execute_move function
	*
	

=end