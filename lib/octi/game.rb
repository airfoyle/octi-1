module Octi
	class Game
		def initialize
			board = Board.new(6,7)
			initial_position = Position.new(board.board)
			GameTree.new(initial_position)
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