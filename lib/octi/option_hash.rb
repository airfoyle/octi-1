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
			puts "\nq: Quit".colorize(:red)
		end

		def loc_include?(arr, l)
			for loc in arr
				if loc.x == l.x && loc.y == l.y
					return true
				end
			end
			return false 
		end
		def choose_key(num, ui, count)
			#check for errors
			puts "Select the #{@h[num][1]} you wish to execute".colorize(:yellow)
			i = 1
			for move in @h[num][0]
				if move.class == Insert
					puts "#{i}: #{move.origin.pretty_string} + #{move.direction[move.x][move.y]}"
				elsif move.class == Hop
					puts "#{i}: #{move.origin.pretty_string} - #{move.destination.pretty_string}" 

				elsif move.class == Jump
				print "#{i}: #{move.origin.pretty_string} - " 

				j=0
				while j < move.steps.length || j < move.jumped_pods.length
					if j < move.steps.length
						if loc_include?(move.jumped_pods, move.steps[j]) 
							print "#{move.steps[j].pretty_string}x - "
						else
							print "#{move.steps[j].pretty_string} - "
						end
					end 
					j = j + 1
				end
				puts "#{move.destination.pretty_string}" 
				end
				i = i +1
			end
			puts "\n0: Previous options".colorize(:yellow)
			puts "q: Quit".colorize(:red)
			choice = ui.get_input("", count)
			if choice == "0"
				return choice.to_i
			elsif choice =~ /[q]$|(quit)/i
				puts "Quitting..."
				abort("Goodbye.")
			end
			choice = choice.to_i
			#puts "i:#{i}"
			while !(1..i).include?(choice)
				puts "Please Choose a valid option.".colorize(:red)
				choose_key(num, ui)
			end
			
			return @h[num][0][choice-1]
		end
	end
end