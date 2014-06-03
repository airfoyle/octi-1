module Octi
	class Board
		attr_reader  :comp, :human, :board, :bases
		def initialize(width, height, comp, human)
			@board = Array.new(height) { Array.new(width, nil) }
			@comp = comp
			@human = human
			human_bases =[]
			comp_bases =[]
			@positions = []
			@bases = Array.new

			1.upto(4) do |i|
				@board[1][i] = Pod.new(@human)
				human_bases << Location.new(1,i)
				@board[5][i] = Pod.new(@comp)
				comp_bases << Location.new(5,i)
			end 
			@positions[@human.index] = human_bases 
			@positions[@comp.index] = comp_bases
			@human.set_bases(human_bases) 
			@comp.set_bases(comp_bases)			
		end

		# def positions(player)
			
		# end

		def board
			return @board
		end

		def comp
			return @comp
		end

		def human
			return @human
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