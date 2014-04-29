module Octi
	class Board
		attr_accessor :board, :comp, :human
		def initialize(width,height)
			@board = Array.new(width) { Array.new(height, nil) }
			@comp = Player.new()
			@human = Player.new()
			
			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				@board[5][i] = Pod.new(@comp)
			end 
		end
	end	
end