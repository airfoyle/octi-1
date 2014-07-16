module Octi
	class Player 
		attr_reader :comp, :human, :index
		attr_accessor :prong_reserve
		def initialize(i, reserve)
			@index = i
			@prong_reserve = reserve
		end

		def index
			return @index
		end

		def prong_reserve
			return @prong_reserve
		end
		def set_prong_reserve(n)
			@prong_reserve = n
		end

		def better_for(v1, v2)
			puts "index: #{@index} | v1 = #{v1}| v2 = #{v2} "
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

		def set_bases(bases)
			@bases = bases
		end

		def bases
			return @bases
		end
		
		def set_opponent_bases(bases)
			@opponent_bases = bases
		end

		def opponent_bases
			return @opponent_bases
		end

	end
end