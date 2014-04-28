
module Octi
	class Pod
		attr_accessor :player

		def initialize(player)
			@prongs = Array.new(8, false)
			self.player = player
		end

		def can_move?(board,x2,y2,x1,y2)
			 dx - x2 - x1
			 dy = y2 - y1

			 #is destination in range?
			 if dx.abs > 1 || dy.abs > 1
			 	return false #can jump?
			 end

			 count = -1
			 for i in -1..1
			 	for j in -1..1
			 		count++
			 		if (0..5)===(x1+i) && (0..6)===(y1+j) #on board
			 			if @prongs[count] 
			 				return true
			 			end
			 		end
			 	end
			 end
		end

		def can_jump?
		end
	end
end

