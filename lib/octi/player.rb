module Octi
	class Player 
		attr_accessor :pods, :positions

		def initialize(i)
			@index = i
		end

		def index
			return @index
		end
	end
end