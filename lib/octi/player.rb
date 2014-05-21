module Octi
	class Player 
		attr_accessor :pods, :positions

		def initialize(i)
			@index = i
			@prong_reserve = 32
		end

		def index
			return @index
		end
	end
end