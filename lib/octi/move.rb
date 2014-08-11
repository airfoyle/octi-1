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
		attr_reader :pod, :prongs, :inserts, :origin, :x, :y
		def initialize(pod,x,y,player)
			@origin = pod #pod location
			@x = x
			@y = y
			@player = player
			#@new_prong_reserve = player.prong_reserve-1
		end

		def execute_move(position)
			count = @player.prong_reserve-1
			
			index = @player.index
			#puts "player: #{@player.inspect}"
			if index == position.comp.index
				new_comp = Player.new(index, count)
				new_human = position.human
				new_comp.set_opponent_bases(position.comp.opponent_bases)
			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
			else
				puts "ERROR".colorize(:yellow)
			end

			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
		
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)

			new_prongs[@x][@y] = true 
			#freeze
			two_array_freeze(new_prongs)
			new_pod = Pod.new(@player)
			new_pod.set_prongs(new_prongs)
			new_array[@origin.x][@origin.y] = new_pod
			two_array_freeze(new_array)

			new_pos = Position.new(new_array, new_comp, new_human)

			return new_pos					
		end

	end

	class Hop < Move
		attr_reader :pod, :prongs, :board, :origin, :destination, :player
		def initialize(origin, destination,player)
			@origin = origin
			@destination = destination
			@player = player
		end

		def execute_move(position)
			index = @player.index
			count = @player.prong_reserve
			if index == position.comp.index
				new_comp = Player.new(index, count)
				new_human = position.human
				new_comp.set_opponent_bases(position.comp.opponent_bases)
			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
			else
				puts "ERROR".colorize(:yellow)
			end

			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
		
			#freeze pod
			new_pod = Pod.new(@player)
			new_array[@destination.x][@destination.y] = new_pod
			new_array[@origin.x][@origin.y] = nil
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)

			new_pos = Position.new(new_array, new_comp, new_human)

			return new_pos
		end	
	end

	class Jump < Move
		attr_reader :pod, :prongs, :board, :origin, :destination, :player, :jumped_pods
		def initialize(origin, destination, jumped_pods, player)
			@origin = origin
			@destination = destination
			@jumped_pods = jumped_pods # locations of pods jumped in board position 
			@player = player
		end
		def set_captures(pods)
			@jumped_pods = pods
		end
		def execute_move(position)
			index = @player.index

			count = @player.prong_reserve
			if index == position.comp.index
				new_comp = Player.new(index, count)
				new_human = position.human
				new_comp.set_opponent_bases(position.comp.opponent_bases)
			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
			else
				puts "ERROR".colorize(:yellow)
			end

			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
		
			#freeze pod
			new_pod = Pod.new(@player)
			new_array[@destination.x][@destination.y] = new_pod
			new_array[@origin.x][@origin.y] = nil
			for cap in @jumped_pods
				new_array[cap.x][cap.y] = nil
			end
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)

			new_pos = Position.new(new_array, new_comp, new_human)
			#start = @origin
			#new_array = position.pods.dup#DeepClone.clone position.pods
			#new_array[@destination.x][@destination.y] = new_array[@origin.x][@origin.y]
			#new_array[@origin.x][@origin.y] = nil
			#new_pos = Position.new(new_array, position.comp, position.human)
			return new_pos
		end	

		def jumped_pods
			return @jumped_pods
		end
	end

	  # Copy a two-dimensional array
	
end

  def two_array_copy(a)
    new_a = Array.new(a.length)
   #  for i in  0 .. (a.length - 1)
   #    new_a[i] = a[0].dup
  	# end
  	new_a = Marshal.load( Marshal.dump( a ) )
    return new_a
  end

  # Freeze a two-dimensional array
  def two_array_freeze(a)
    for i in 0 .. (a.length - 1)
       a[i].freeze
   	end
    a.freeze
  end
