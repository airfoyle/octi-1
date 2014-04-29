module Octi
	class GameState
		attr_accessor  :board, :moves

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

		def initialize(comp, human, board)
			self.board = board #position
			comp_pos = comp.positions #list of pod positions comp
			human_pos = comp.positions #list of pod positions human
			
			#self.moves = []		#list of possible moves
		end
	end
end