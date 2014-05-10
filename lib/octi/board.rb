module Octi
	class Board
		attr_accessor :board, :comp, :human, :positions
		def initialize(width,height)
			@board = Array.new(width) { Array.new(height, nil) }
			

			
			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				@human.positions << Location.new(1,i)
				@board[5][i] = Pod.new(@comp)
				@comp.positions << Location.new(5,i)
			end 
		end

		def base?(position) #take pod position [x,y]
			if @human.positions.include? (position)
				return true
			else 
				return false
			end
		end
		def comp_base?(position) #take pod position [x,y]
			if @comp.positions.include? (position)
				return true
			else 
				return false
			end
		end

	end	
end