module Octi
	class Board
		attr_reader  :comp, :human, :board, :bases, :height, :width
		def initialize(width, height, comp, human)
			@board = Array.new(height) { Array.new(width, nil) }
			@comp = comp
			@human = human
			human_bases =[]
			comp_bases =[]
			@positions = []
			@bases = Array.new
			@height = height
			@width = width
			1.upto(4) do |i|
				@board[i][1] = Pod.new(@comp)
				comp_bases << Location.new(i,1)
				@board[i][5] = Pod.new(@human)
				human_bases << Location.new(i,5)
			end 
			@positions[@human.index] = human_bases 
			@positions[@comp.index] = comp_bases

			@human.set_opponent_bases(comp_bases) 
			@comp.set_opponent_bases(human_bases)

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