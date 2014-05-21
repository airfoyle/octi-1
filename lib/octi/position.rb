module Octi
	class Position
		attr_accessor :comp, :human
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
=begin	
				pod.prongs.each_with_index do |row, i|
					row.each_with_index do |col, j|
						# if pod.prongs[i][j] && ((0..5)===(@x+2*i) && (0..6)===(@y+2*j))
						# 	if @pods[l.x+i][l.y+j].is_a?(Pod) && @pods[l.x+2*i][l.y+2*j] == nil
						# 		jumped = @pods[l.x+i][l.y+j]
								
						# 		to = @pods[l.x+2*i][l.y+2*j]
						# 		if from == nil
						# 			from = pod
						# 			jump << Jump.new(from, to, jumped)
						# 		else
						# 			jump<< Jump.new(from, to, jumped)
						# 			jumps(player, from)
						# 		end

						# 	end
						# end
						jump = help(i,j, jumped, jump, nil)
					end
				end
=end
			end
			captured(jump)
			return jump
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
			
		end

		# def help(i,j, jumped, jump, from, target_x, target_y)
		# 	if pod.prongs[i][j] && ((0..5)===(@x+2*i) && (0..6)===(@y+2*j)) #on board
		# 		if @pods[target_x+i][target_y+j].is_a?(Pod) && @pods[target_x+2*i][target_y+2*j] == nil #empty target squre
		# 			jumped = @pods[l.x+i][l.y+j]	#jumped pod					
		# 			to = @pods[target_x+2*i][target_y+2*j]1	#target square
		# 			if from == nil					#first jump in series?
		# 				from = pod
		# 				jump << Jump.new(from, to, jumped)
		# 				help(l.x+2*i,l.x+2*j, jumped, jump, from)
		# 			else							#mid-series
		# 				jump << Jump.new(from, to, jumped)
		# 				help(l.x+2*i,l.x+2*j, jumped, jump, from)
		# 			end
		# 		else
		# 			return jump
		# 		end
		# 	end
		# end

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
	end
end

