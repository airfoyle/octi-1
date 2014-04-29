
module Octi
	class Pod
		attr_accessor :player

		def initialize(player)
			@prongs = Array.new(8, false)
			self.player = player
		end

		def can_move?(board,x1,y1)
			count = -1
			for i in -1..1
				for j in -1..1
					count++
					if (i&&j) == 0
						next
					elsif ((0..5)===(x1+i) && (0..6)===(y1+j)) #on board
						if (@prongs[count]  && boad[x1+i][y1+j] ==nil)
							return true
						end
					end
				end
			end
		end

		
		def can_jump?
			#is there a prong?
			#is there a pod to jump over
			#is cell after pod nil?
		end
	end
end

