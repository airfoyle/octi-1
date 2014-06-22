module Octi
	class Move
		attr_reader :pod, :prongs, :board, :game_state, 
		#attr_accessor :player

		def initialize(origin, destination) #locations
			@origin = origin
			@destination = destination
 		end

		def execute_move(position)
		end
	end

	class Insert < Move
		attr_reader :pod, :prongs, :inserts
		def initialize(pod,x,y,player)
			@origin = pod #pod location
			@x = x
			@y = y
			@player = player
		end

		def execute_move(position)
			count = @player.prong_reserve-1
			new_array = position.pods.dup#DeepClone.clone position.pods
			if @player == position.comp
				position.comp.prong_reserve = count
			else
				position.human.prong_reserve = count
			end
			
			pod = new_array[@origin.x][@origin.y]
			pod.prongs[@x][@y] = true
			new_pos = Position.new(new_array, position.comp, position.human)

			return new_pos					
		end

	end

	class Hop < Move
		attr_reader :pod, :prongs, :board
		def initialize(origin, destination)
			@origin = origin
			@destination = destination
		end

		def execute_move(position)
			new_array = position.pods.dup#DeepClone.clone position.pods
			new_array[@destination.x][@destination.y] = new_array[@origin.x][@origin.y]
			new_array[@origin.x][@origin.y] = nil
			new_pos = Position.new(new_array, position.comp, position.human)
			return new_pos
		end	
	end

	class Jump < Move
		attr_reader :pod, :prongs, :board
		def initialize(origin, destination, jumped_pods)
			@origin = origin
			@destination = destination
			@jumped_pods = jumped_pods # locations of pods jumped in board position 
		end

		def execute_move(position)
			start = @origin
			new_array = position.pods.dup#DeepClone.clone position.pods
			new_array[@destination.x][@destination.y] = new_array[@origin.x][@origin.y]
			new_array[@origin.x][@origin.y] = nil
			new_pos = Position.new(new_array, position.comp, position.human)
			return new_pos
		end	

		def jumped_pods
			return @jumped_pods
		end
	end	
end
