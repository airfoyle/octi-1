module Octi
	class GameState
		attr_accessor :current_player, :board, :moves

		class Cache
			attr_accessor :states
			def initialize
				@states = {}
			end
		end

		class << self
			attr_accessor :cache
		end
		self.cache = Cache.new

		def initialize(board)
			self.board = board #position
			#list of pod positions comp
			#list of pod positions human
			
			#self.moves = []		#list of possible moves
		end
	end
end