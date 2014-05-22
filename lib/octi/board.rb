module Octi
	class Board
		attr_reader :board, :comp, :human, :positions
		def initialize(width,height)
			@board = Array.new(width) { Array.new(height, nil) }
			
			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				human_bases << Location.new(1,i)
				@board[5][i] = Pod.new(@comp)
				comp_bases << Location.new(5,i)
			end 
			@positions[@human.index] = human_bases 
			@positions[@comp.index] = comp_bases
			@bases[@human.index] = human_bases 
			@bases[@comp.index] = comp_bases			
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