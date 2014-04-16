
module Octi
	class Pod
		attr_accessor :player

		def initialize(player)
			@prongs = Array.new(8, false)
			self.player = player
		end

		def can_move?
		end

		def can_jump?
		end
	end
end

