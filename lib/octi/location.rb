module Octi
	class Location
		@@board_height = 7
		def initialize(x,y)
			@x = x
			@y = y
		end

		def x
			return @x
		end

		def y
			return @y
		end
		def pretty_string
          return (@x+1).to_s + (@@board_height - @y).to_s
        end		
	end

end