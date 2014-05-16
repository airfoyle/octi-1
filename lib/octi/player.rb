module Octi
	class Player 
		attr_accessor :pods, :positions

		def initialize(i)
			@index = i
		end

		def index
			return @index
		end
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