module Octi
	class Position
		attr_accessor :comp, :human
		attr_reader :bases
		def initialize(pods)
			@pods = pods.dup
			@podLocs = Array.new() { Array.new(nil) }
			@podLocs[comp.index] = find_pods_for_player(comp)
			@podLocs[human.index] = find_pods_for_player(human)
			@prongs = Array.new() { Array.new(nil) }
			@prongs[comp.index] = comp.prong_reserve
			@prongs[human.index] = human.prong_reserve
		
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
							inserts << Insert.new(pod,x,y, player)				
						end
					end
				end	
			end	
			return inserts	
		end

		def hops(player)
			#returns origin and destination
			hops_total = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]  # pod of playerb
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						if ((0..5)===(@x+i) && (0..6)===(@y+j) && @pods[l.x+i][l.y+j] == nil)
							from = pod
							to = @pods[l.x+i][l.y+j]
							hops_total<< Hop.new(from, to)
						end
					end
				end
			end
			return hops_total
		end


		def jumps(player)
			#returns origin and destination
			jumped = []
			jump = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]
				jump =jumpy(pod, jumped, l.x, l.y, l.x, l.y)
			end
			#captured(jump)
			return captured(jump)
		end

		def jumpy(pod, jumped_p, start_x, start_y, curr_x, curr_y)
			pod.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|
					if pod.prongs[i][j] && ((0..5)===(curr_x+2*i) && (0..6)===(curr_y+2*j)) #on board
						if @pods[curr_x+i][curr_y+j].is_a?(Pod) && @pods[curr_x+2*i][curr_y+2*j] == nil 
							from = @pods[start_x+i][start_y+j]
							to = @pods[curr_x+2*i][curr_y+2*j]
							jumped_p << @pods[curr_x+i][curr_y+j]

							return Jump.new(from, to, jumped_p), jumpy(pod, jumped_p, start_x, start_y, curr_x+2*i, curr_y+2*j)
						end
					else
						return 
					end
				end
			end
		end

		def captured(jumps)
			for jump in jumps
				if jump.jumped_p.empty?
					return 
				else
					for i in 0..(jump.jumped_p.length) do
						new_jump = jump.dup
						new_jump.jumped_p = a.combination(i).to_a
						idx = jumps.index(jump)
						jumps.insert(idx, new_jump)
					#	jumps << new_jump
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

		def count_prongs(player)
			count = 0
			podLocs
			
		end
		def self.heuristic_value
			
			#distance to base
			pods = self.pods #are scores player specific or do they take opponent into account
			podlocs = self.podLocs

			#x number of pods
			#prongs in reserve 
				#player.prongs_in_reserve
			#prongs on board
			number_of_pods = 0
			distance_to_base = 100
			prongs_on_board = 0
			c_mobility_arr = self.hops(comp)
			h_mobility_arr = self.hops(human)
			for l in podlocs[comp.index]
				if pods[l.x][l.y].is_a?(Pod)
					c_number_of_pods++
					c_distance_to_base = distance(l, player, distance_to_base)
					pod.prongs.each_with_index do |row, i|
						row.each_with_index do |col, j|
							if pod.prongs[i][j]
								c_prongs_on_board++
							end
						end
					end
				end
			end
			for l in podlocs[human.index]
				if pods[l.x][l.y].is_a?(Pod)
					h_number_of_pods++
					h_distance_to_base = distance(l, player, distance_to_base)
					pod.prongs.each_with_index do |row, i|
						row.each_with_index do |col, j|
							if pod.prongs[i][j]
								h_prongs_on_board++
							end
						end
					end
				end
			end


			prong_count = (comp.prongs_in_reserve - c_prongs_on_board) - (human.prongs_in_reserve - h_prongs_on_board)
			mobility = c_mobility_arr.length + h_mobility_arr.length
			number_of_pods = c_number_of_pods - h_number_of_pods
			distance_to_base = (h_distance_to_base - c_distance_to_base)*10
			#prong distribution -mobility

			return distance_to_base*2 + number_of_pods*5 + prong_count/4 + mobility/4
		end	

		def distance(l, player, distance_to_base)
			if player  == @comp
				1.upto(4) do |i|
					dist = sqrt((l.x-1)**2+(l.y-i)**2)
					if dist < distance_to_base
						distance_to_base = dist
					end
				end
			elsif player  == @human
				1.upto(4) do |i|
					dist = sqrt((l.x-5)**2+(l.y-i)**2)
					if dist < distance_to_base
						distance_to_base = dist #negative
					end
				end
			end	
			return distance_to_base	
		end

		def game_ended?
			if self.end_value != nil
				true
			else
				return false
			end
		end

		def end_value
			#if pod is on enemy base
			podLocs[comp.index].each do |pod| 
				bases[human.index].each do |base|
					if pod == base
						return 100
					end
				end
			end

			podLocs[human.index].each do |pod| 
				bases[comp.index].each do |base|
					if pod == base
						return -100
					end
				end
			end

			return nil
			
		end
	end
end

