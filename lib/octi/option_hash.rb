module Octi
	class OptionHash
		attr_reader :move
		def initialize(moves, player)
			@all_moves = moves
			@inserts = moves[0]
			@hops = moves[1]
			@jumps = moves[2]
			@player = player

			@h = Hash.new
			if @inserts.length > 1
				@h[1] = [@inserts, "Insert"]
			end
			if @hops.length > 0
				@h[2] = [@hops, "Hop"]
			end
			if @jumps.length > 0
				@h[3] = [@jumps, "Jump"]
			end 
		end

		def print_options
			@h.each do |key, value|
				if value[0].length > 0
					puts "#{key}: #{value[1]} moves = #{value[0].length}"
				end
			end
			#@player.z
		end

		def choose_key(num, ui, count)
			#check for errors
			puts "Select the #{@h[num][1]} you wish to execute".colorize(:yellow)
			i = 1
			for move in @h[num][0]
				if move.class == Insert
					puts "#{i}: Pod Location:(#{move.origin.x}, #{move.origin.y}) | Direction: #{move.direction[move.x][move.y]}" #color?
				elsif move.class == Hop
					puts "#{i}: Pod Location:(#{move.origin.x}, #{move.origin.y}) | Pod Destination: (#{move.destination.x}, #{move.destination.y})" 

				else
				puts "#{i}: #{move.class}|Pod Location:(#{move.origin.x}, #{move.origin.y}) | Pod Destination: (#{move.destination.x}, #{move.destination.y})|captures: #{move.jumped_pods}"
				end
				i = i +1
			end
			choice = ui.get_input("", count).to_i
			#puts "i:#{i}"
			while !(1..i).include?(choice)
				puts "Please Choose a valid option.".colorize(:red)
				choose_key(num, ui)
			end
			return @h[num][0][choice-1]
		end
	end
end