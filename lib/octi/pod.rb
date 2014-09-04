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
				if prong && prong != 0
					count = count+1
				end
			end
			return count
		end
		
		def print_prongs
			@prongs.each_with_index do |col, i|
				col.each_with_index do |row, j|
					if @prongs[i][j] == true && !(i == 1 && j == 1)
						puts "(#{i}, #{j})"
					end
				end
			end
		end
	end
end

