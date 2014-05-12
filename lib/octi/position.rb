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
			#returns coordinates of a new prong 
			inserts = []
			for l in @podLocs[player.index]
				pod = @pod[l.x][l.y]
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						if !pod.prongs[x][y]
							inserts << Insert.new(x,y)				
						end
					end
				end	
			end	
			return inserts	
		end

		def hops(player)
			#returns origin and destination
			hops = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]  # pod of player
				#what are the hop destinations for this origin?
					#check prongs for legal movement and return list of possible hops?
					#¿when you make a move, return?
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						if ((0..5)===(@x+i) && (0..6)===(@y+j) && @pods[l.x+i][l.y+j] == nil)
							from = pod
							to = @pods[l.x+i][l.y+j]
							hops<< Hop.new(from, to)
						end
					end
				end
			end
			return hops
		end


		def jumps(player)
			#returns origin and destination
			jumps = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						if pod.prongs[i][j] && ((0..5)===(@x+2*i) && (0..6)===(@y+2*j))
							if @pods[l.x+i][l.y+j].is_a?(Pod) && @pods[l.x+2*i][l.y+2*j] == nil
								
								from = pod
								to = @pods[l.x+2*i][l.y+2*j]
								jumps << Jump.new(from, to)

							end
						end
					end
				end
			end
			return jumps
		end

		#return array of player's pod locations 
		def find_pods_for_player(player)
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

