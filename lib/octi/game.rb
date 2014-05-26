module Octi
	class Game
		attr_accessor :board
		def initialize
			board = Board.new(6,7, Player.new(0), Player.new(1))
			initial_position = Position.new(board)
			GameTree.new(initial_position)
		end
	end
end

