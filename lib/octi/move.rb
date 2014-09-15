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
		attr_reader :pod, :prongs, :inserts, :origin, :x, :y, :direction, :new_prong_reserve
		def initialize(pod,x,y,player)
			@origin = pod #pod location
			@x = x
			@y = y
			@player = player
			@direction = Array.new(3) { Array.new(3) }
			@direction[0][0] = "H"#:Northwest"
			@direction[1][0] = "A"#:North"
			@direction[2][0] = "B"#:Northeast"
			@direction[0][1] = "G"#:West"
			@direction[0][2] = "F"#:Southwest"
			@direction[1][2] = "E"#:South"
			@direction[2][1] = "C"#:East"
			@direction[2][2] = "D"#:Southeast"
			

			@new_prong_reserve = player.prong_reserve-1
		end

		def execute_move(position)

			count = @new_prong_reserve
			
			index = @player.index
			if index == position.comp.index
				new_comp = Player.new(index, count)
				new_human = position.human
				new_comp.set_opponent_bases(position.comp.opponent_bases)
				new_comp.set_bases(position.comp.bases)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)


			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
		
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)

			new_prongs[@x][@y] = true 
			#freeze
			two_array_freeze(new_prongs)
			new_pod = Pod.new(new_comp)
			new_pod.set_prongs(new_prongs)
			new_array[@origin.x][@origin.y] = new_pod
			two_array_freeze(new_array)
			
			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)
				new_comp.set_opponent_bases(position.comp.opponent_bases)
				new_comp.set_bases(position.comp.bases)


			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
		
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)

			new_prongs[@x][@y] = true 
			#freeze
			two_array_freeze(new_prongs)
			new_pod = Pod.new(new_human)
			new_pod.set_prongs(new_prongs)
			new_array[@origin.x][@origin.y] = new_pod
			two_array_freeze(new_array)
			
			else
				puts "ERROR".colorize(:yellow)
			end

		
			new_pos = Position.new(new_array, new_comp, new_human)

			
			return new_pos					
		end
	end

        # Shift a prong within a pod
        class Shift < Move
          attr_reader :x, :y, 

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
				new_comp.set_bases(position.comp.bases)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)

					#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
		
			#freeze pod
			new_pod = Pod.new(new_comp)
			new_array[@destination.x][@destination.y] = new_pod
			new_array[@origin.x][@origin.y] = nil
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)
			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)
				new_comp.set_opponent_bases(position.comp.opponent_bases)
				new_comp.set_bases(position.comp.bases)

					#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
		
			#freeze pod
			new_pod = Pod.new(new_human)
			new_array[@destination.x][@destination.y] = new_pod
			new_array[@origin.x][@origin.y] = nil
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)
			else
				puts "ERROR".colorize(:yellow)
			end

		

			new_pos = Position.new(new_array, new_comp, new_human)

			return new_pos
		end	
	end

	class Jump < Move
		attr_reader :pod, :prongs, :board, :origin, :destination, :player, :jumped_pods,:steps
		def initialize(origin, destination, steps, jumped_pods, player)
			@origin = origin
			@destination = destination
			@steps = steps
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
				new_comp.set_bases(position.comp.bases)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)


			#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
			#freeze pod
			new_pod = Pod.new(new_comp)
			new_array[@destination.x][@destination.y] = new_pod

			

			add_to_prong_reserve = 0

			if !jumped_pods.empty?
				#puts "jumped_pods: #{jumped_pods}"
				for cap in jumped_pods
					pod = new_array[cap.x][cap.y] 
					if pod.is_a?(Pod)
						add_to_prong_reserve = add_to_prong_reserve + pod.prong_count
						new_array[cap.x][cap.y] = nil
					else
						#debugger
					end
					
				end
			end
			new_array[@origin.x][@origin.y] = nil
			#add to player's reserve
			new_comp.set_prong_reserve(new_comp.prong_reserve+add_to_prong_reserve)
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)

			elsif index == position.human.index
				new_comp = position.comp
				new_human = Player.new(index, count)
				new_human.set_opponent_bases(position.human.opponent_bases)
				new_human.set_bases(position.human.bases)
				new_comp.set_opponent_bases(position.comp.opponent_bases)
				new_comp.set_bases(position.comp.bases)

				#New pod array 
			#new_array = position.pods.dup#DeepClone.clone position.pods
			new_array = two_array_copy(position.pods)
			pod = new_array[@origin.x][@origin.y]
			new_prongs = two_array_copy(pod.prongs)
			#freeze pod
			new_pod = Pod.new(new_human)
			new_array[@destination.x][@destination.y] = new_pod

			

			add_to_prong_reserve = 0

			if !jumped_pods.empty?
				#puts "jumped_pods: #{jumped_pods}"
				for cap in jumped_pods
					pod = new_array[cap.x][cap.y] 
					if pod.is_a?(Pod)
						add_to_prong_reserve = add_to_prong_reserve + pod.prong_count
						new_array[cap.x][cap.y] = nil
					else
						#debugger
					end
					
				end
			end
			new_array[@origin.x][@origin.y] = nil
			#add to player's reserve
			new_human.set_prong_reserve(new_human.prong_reserve+add_to_prong_reserve)
			two_array_freeze(new_array)

			#freeze prongs
			two_array_freeze(new_prongs)
			new_pod.set_prongs(new_prongs)
			else
				puts "ERROR".colorize(:yellow)
			end


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

  def self.read_move(srm)
    # Move must fit on one line, for now
    tokens_to_move(tokenize(srm.gets.chomp!))
  end

  def tokenize(line)
    tokens = []
    line = line.lstrip!
    while line.length > 0
      if line.match(/^[1-9][1-9]/, index) then    
        tokens.push(Location.from_string(line[0..1]))
        line = line[2..-1]
      elsif line.match(^[A-Ha-h])
        tokens.push(line[0].upcase)
        line = line[1..-1]
      elsif line.match(/^[+-x]/)
        tokens.push(line[0])
        line = line[1..-1]
      else
        raise InputError("Bogosity in move description starts here: #{line}")
      end
      line.lstrip!
    end

    def tokens_to_move(tokens)
      if tokens.length < 1 || tokens[0].instance_of?(Location) 
        raise ParseError.new("Move must start with pod location")
      elsif tokens.length < 2 || not (tokens[1].instance_of?(String))
        raise ParseError.new("Move must have character (+ or -) as second token.")
      elsif (tokens[1] == '+')
        if tokens.length > 2 && tokens[2].instance_of?(String)
          chp = tokens[2]
          if (chp = 'A' && chp <= 'H')
            # Insert-prong or move-prong
            chpi = chp  - 'A'
            if tokens.length > 3
              if tokens.length > 4 && tokens[3] == '-' && tokens[4].instance_of?(String)
                chm = tokens[4]
                if chm >= 'A' && chm <= 'H'
                  # Move-prong
                  chmi = chm - 'A'
                  return Shift.new(
        
    end



  end

  class ParseError < StandardError
    def initialize(msg)
       super(msg)
    end

	
end

  # Copy a two-dimensional array
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

