module Octi
	class Player 
		attr_reader :comp, :human

		def initialize(i)
			@index = i
			@prong_reserve = 32
		end

		def index
			return @index
		end

		def better_for(v1, v2)
			if @index == 0 && (v1 > v2)
				return true
			elsif @index == 1 && (v1 < v2)
				return true
			else
				return false
			end
		end

		def worst_value
			if @index == 0
				return -100
			else
				return 100
			end
		end

		def other_player
			if @index == 0
				return human
			else
				return comp
			end
		end
	end
end