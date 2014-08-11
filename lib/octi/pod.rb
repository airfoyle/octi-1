module Octi
	class Pod
		attr_reader :player,:prongs

		def initialize(player)
			@prongs = Array.new(3) { Array.new(3, false) }
			@prongs[1][1] = 0
			@player = player
		end
		def player
			return @player
		end

		def set_prongs(n)

			@prongs = n
		end

		def prong_count
			count = 0 
			for prong in @prongs
				if prong 
					count+1
				end
			end
			return count
		end
	end
end

