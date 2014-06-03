module Octi
	class Player 
		attr_reader :comp, :human, :index
		attr_accessor :prong_reserve
		def initialize(i)
			@index = i
			@prong_reserve = 32
		end

		def index
			return @index
		end

		def prong_reserve
			return @prong_reserve
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

		def set_bases(bases)
			@bases = bases
		end

		def bases
			return @bases
		end

	end
end