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

		def initialize(current_player, board)
			self.current_player = current_player
			self.board = board #position
			self.moves = []		#list of possible moves
		end

		def 

	end
end