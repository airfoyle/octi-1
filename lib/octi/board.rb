module Octi
	class Board
		attr_accessor :board, :comp, :human, :positions
		def initialize(width,height)
			@board = Array.new(width) { Array.new(height, nil) }
			@comp = Player.new()
			@human = Player.new()
			
			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				@human.positions << [@board[1][i], 1, i]
				@board[5][i] = Pod.new(@comp)
				@comp.positions << [@board[5][i], 5, i]
			end 
		end
	end	
end