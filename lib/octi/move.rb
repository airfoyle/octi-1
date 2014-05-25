module Octi
	class Move
		attr_reader :pod, :prongs, :board, :game_state, 
		attr_accessor :player

		def initialize(origin,destination) #locations
			@origin = origin
			@destination = destination
 		end

		def execute_move(position)
		end
	end

	class Insert < Move
		attr_reader :pod, :prongs, :inserts
		def initialize(pod,x,y,player)
			@origin = pod.dup
			@x = x
			@y = y
			@player = player
		end

		def execute_move(position)
			@player.prong_reserve--
			if !@origin.prongs[@x][@y]
				@origin.prongs[@x][@y] = true
				return position					
			end
		end

	end

	class Hop < Move
		attr_reader :pod, :prongs, :board
		def initialize(origin,destination)
			super
		end

		def execute_move(position)
			board = position.pods.dup
			board[@destination.x][@destination.y] = board[@origin.x][@origin.y]
			board[@origin.x][@origin.y] = nil
			new_pos = Position.new(board)
		end	
	end

	class Jump < Move
		attr_reader :pod, :prongs, :board
		def initialize(origin, destination, jumped_pods)
			super
			@jumped_pods = jumped_pods # num of pods jumped in position 
		end

		def execute_move(position)
			start = @origin
			board = position.pods.dup
			board[@destination.x][@destination.y] = board[@origin.x][@origin.y]
			board[@origin.x][@origin.y] = nil
			new_pos = Position.new(board)

		end	
	end	
end
