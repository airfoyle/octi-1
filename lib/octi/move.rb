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
          # Integers from 0 to 7 specifying where the peg is added and where it
          # came from
          attr_reader :dest, :source
          def initialize(loc, dest, source)
            super(loc, loc)
            @dest = dest
            @source = source
          end
        end

        # Slide a pod one square, horizontally, vertically, or diagonally,
        # provided you have a peg licensing the move.
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
                # jumped_pods is a misnomer; they are the captured pods.
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
  end

  def read_move(srm)
    # Move must fit on one line, for now
    line = srm.gets.chomp!
    tokens_to_move(tokenize(line), line)
  end

  # Convert a line of characters to "tokens," which are locations with characters (+, -, and x)
  # interspersed.
  def tokenize(given_line)
    tokens = []
    line = String.new(given_line).lstrip!
    while line.length > 0
      if line.match(/^[1-9][1-9]/, index) then    
        tokens.push(Location.from_string(line[0..1]))
        line = line[2..-1]
      elsif line.match(/^[A-Ha-h]/)
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
    tokens
  end

  # Convert a list of "tokens" to a move.  A token is a Location
  # or a character (+, -, x)
    def tokens_to_move(tokens, given_line)
      if tokens.length >= 1 && tokens[0].instance_of?(Location)
        loc0 = tokens[0]
        loc0_pretty = loc0.pretty_string()
        if tokens.length >=2 && tokens[1].instance_of?(String)
          chr1 = tokens[1]
          if chr1 == '+'
            if tokens.length == 3
              # Insert-prong 
              chp = tokens[2]
              if chp >= 'A' && chp <= 'H'
                chpi = chp  - 'A'
                return Insert.new(loc0,chpi)
              else
                raise ParseError.new("Illegal peg in Insert move: #{loc0_pretty}+#{chp}")
              end
            elsif tokens.length == 5 && tokens[3] == '-'
              # Shift-prong
              chp = tokens[2]
              chm = tokens[4]
              chp_good = (chp >= 'A' && chp <= 'H')
              chm_good = (chm >= 'A' && chm <= 'H')
              if chp_good && chm_good
                chpi = chp - 'A'
                chmi = chm - 'A'
                return Shift.new(loc0, chpi, chmi)
              else
                which_bad = if !chp_good && chm_good
                              "destination"
                            elsif chp_good && !chm_good
                              "source"
                            else
                              "destination and source"
                            end
                raise ParseError.new("Illegal peg #{which_bad} in Shift move: #{loc0_pretty}+#{chp}-#{chm}")
              end
            end
          elsif chr1 == '-'
            tokens_to_hop_or_jump(tokens, loc0)
          else
            raise ParseError.new("Illegal character after starting location: #{loc0_pretty}#{chr1}...")
          end
        end
      else
        raise ParseError.new("Move must start with pod location not #{tokens[0]} [in \"#{given_line}\"]")
      end
  end

  # Parse a Hop or Jump starting with loc0.  We already know that the second token is '-'
  def tokens_to_hop_or_jump(tokens, loc0)
    if tokens.length == 3 && tokens[2].instance_of?(Location)
      # Hop -- easy.  I'm betting the third argument is irrelevant
      return Hop.new(loc0, token[2], nil)
    else
      # Now it gets tough.
      tokens.delete_at(0)
      captured = []
      steps = []
      keep_going = true
      prev = loc0
      while keep_going
        jumped_loc, j_captured = dequeue_loc(tokens)
        if j_captured
          captured.push(jumped_loc)
        end
        next_dest, captured = dequeue_loc(tokens)
        if captured
          # You can't capture the square you're jumping to
          prev_pretty = prev.pretty_string()
          jumped_pretty = jumped_loc.pretty_string()
        
          if j_captured
            jumped_pretty += "x"
          end
          next_pretty = next_dest.pretty_string()
          
          raise ParseError.new("'x' in inappropriate position: ...#{prev_pretty}-#{jumped_pretty}-#{next_pretty}x...")
        else
          steps.push(next_dest)
          prev = next_dest
          keep_going = tokens.length > 0
        end
      end
      final_dest = steps.pop();
      # We'll bet that last arg is unim
      return Jump.new(origin, final_dest, steps, captured, nil)
    end
  end

  # Remove a Location from the front of tokens, or raise a ParseError
  def dequeue_loc(tokens)
    if tokens.length > 0 && tokens[0].instance_of?(Location)
      loc = tokens[0]
      tokens.delete_at(0)
      return loc
    elsif tokens.length > 0 
      raise ParseError.new("Unexpected token [#{tokens[0]}] where location expected")
    else
      raise ParseError.new("Tokens end prematurely; expecting location")
    end
  end

  class ParseError < StandardError
    def initialize(msg)
       super(msg)
    end
  end
	
end

  # Copy a two-dimensional array
  def two_array_copy(a)
    new_a = Array.new(a.length)
    new_a.each.dup
    return new_a
  end

  # Freeze a two-dimensional array
  def two_array_freeze(a)
    for i in 0 .. (a.length - 1)
       a[i].freeze
   	end
    a.freeze
  end

