module Octi
	class Position
		attr_accessor :comp, :human
		def initialize(pods)
			@pods = pods.dup
			@podLocs = Array.new() { Array.new(nil) }
			@podLocs[comp.index] = find_pods_for_player(comp)
			@podLocs[human.index] = find_pods_for_player(human)
			
		end

		def legal_moves(player)
			return (prong_inserts(player) + hops(player) + jumps(player))
		end

		def prong_inserts(player)
			for pod in @podLocs[comp.index]
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						new_b = Board.new(6,7)
						val = Insert.new(new_b.board, position).make(i,j)
						val ? results << val : next
					end
				end	
			end		
		end

		def hops(player)
			
		end


		def jumps(player)
			for pod in @podLocs[comp.index]
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						new_b = Board.new(6,7)
						val = Jump.new(new_b.board, position).make(i,j)
						if val
							results << val
							generate_jumps(game_state, position, results)
						end
					end
				end
			end
		end

		#return array of player's pod locations 
		def find_pods_for_player(pods, player)
			results = []
			@pods.each_with_index do |row, i|
				row.each_with_index do |col, j|	
					if @pods[i][j].is_a?(Pod) &&  @pods[i][j].player == player 
						results << Location.new(i,j) #consider returning just location
					end
				end
			end
		end
	end
end

