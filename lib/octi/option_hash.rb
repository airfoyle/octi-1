module Octi
	class OptionHash
		def initialize(moves)
			@all_moves = moves
			@inserts = moves[0]
			@hops = moves[1]
			@jumps = moves[2]

			@h = Hash.new
			@h[1] = [@inserts, "Insert"]
			@h[2] = [@hops, "Hop"]
			@h[3] = [@jumps, "Jump"]
		end

		def print_options
			@h.each do |key, value|
				puts "#{key}: #{value[1]} moves = #{value[0].length}"
			end
		end

		def choose_key(num)
			puts "Select the #{@h[num][1]} you wish to execute"
			
			for move in @h[num][0]
				i = 1
				puts "#{i}: #{move}"
				i = i +1
			end
		end
	end
end