module Octi
	class Board
		attr_accessor :board, :comp, :human, :positions
		def initialize(width,height)
			@board = Array.new(width) { Array.new(height, nil) }
			@comp = Player.new()
			@human = Player.new()
			
			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				@human.positions << [ 1, i]
				@board[5][i] = Pod.new(@comp)
				@comp.positions << [ 5, i]
			end 
		end
	end	
end