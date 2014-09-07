module Octi
	class Position
		def initialize(pods, comp, human)
			@pods = Marshal.load( Marshal.dump(pods) ) #DeepClone.clone pods
			@comp =  comp
			@human = human
			@podLocs = Array.new() { Array.new() }
			
			@podLocs[@comp.index] = find_pods_for_player(@comp)
			@podLocs[@human.index] = find_pods_for_player(@human)
			@prongs = Array.new() { Array.new() }
			@prongs[@comp.index] = @comp.prong_reserve
			@prongs[@human.index] = @human.prong_reserve
			
			
		end

		def podLocs
			return @podLocs
		end

		def pods
			return @pods
		end

		def comp
			return @comp
		end

		def human
			return @human
		end

		def legal_moves(player)
			return [prong_inserts(player), hops(player), jumps(player)] #, jumps(player)
		end

		def has_prongs(pod, i, j)
			if pod.prongs[i][j] == true && pod.prongs[i][j] != 0
				return true
			elsif pod.prongs[i][j] == 0
				return 0
			else
				return false
			end
		end
		
		# def opposite_prongs?(pod, i, j)
		# 	#todo
		# end
		
		def on_board(x,y)
			if (0..5)===(x) && (0..6)===(y)
				return true
			else
				return false
			end
		end

		def prong_inserts(player)
			#returns coordinates of a new prong 
		
			inserts = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]
				pod.prongs.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if player.prong_reserve > 0
							if !has_prongs(pod,i,j) && !(i == 1 && j == 1)
								inserts << Insert.new(l,i,j, player)				
							end
						else
							return inserts	
						end
					end
				end	
			end	

			return inserts	
		end

		def hops(player)
			#returns origin and destination
		#	debugger
			hops_total = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]  # pod of playerb
				pod.prongs.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if has_prongs(pod,i,j) && !(i == 1 && j == 1)
							delta_x = i - 1
							delta_y = j- 1
							d = Location.new(l.x+delta_x, l.y+delta_y) # destination
							if (on_board(d.x,d.y) && @pods[d.x][d.y] == nil)
								from = Location.new(l.x,l.y)
								to = Location.new(d.x,d.y)
								hops_total << Hop.new(from, to, player)
							end
						end
					end
				end
			end
			return hops_total
		end


		def jumps(player)
			#returns origin and destination

			avoid = []
			jumps = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]
				jumps << jumpy(pod,l,l, player, avoid, [])
			end
	
			return jumps.flatten
		end

		def jumpy(pod,s,  c, player, avoid,steps)
			results = Array.new
			pod.prongs.each_with_index do |col, i|
				col.each_with_index do |row, j|
					if has_prongs(pod,i,j) && !(i == 1 && j == 1)
						#debugger
						delta_x = i - 1
						delta_y = j - 1
						delta_i = delta_x*2
						delta_j = delta_y*2
						d = Location.new(c.x+delta_i, c.y+delta_j) #d = destination 
						pod_loc = Location.new(c.x+delta_x, c.y+delta_y) #c = captured pod

						#destination is on board and pod is being jumped to get to destination
						if on_board(d.x, d.y) && @pods[pod_loc.x][pod_loc.y].is_a?(Pod) && (@pods[d.x][d.y] == nil) && !avoid_loc(pod_loc, avoid)
		
							from = Location.new(s.x,s.y)
							to = Location.new(d.x,d.y) 

							results << captured(Jump.new(from, to, steps+[pod_loc], avoid+[pod_loc], player))
							return results+jumpy(pod, s,d, player, avoid+[pod_loc], steps+[pod_loc,d])
						end
					end
				end
			end
			return results.flatten
		end
		
		#check if pod should be avoided0
		def avoid_loc(pod_loc, avoid)
			for l in avoid 
				if (l.x == pod_loc.x) && (l.y ==pod_loc.y)
					return true
				end
			end
			return false 
		end
		def captured(jump)
			if jump.jumped_pods.flatten.empty?
				return jump
			end 
			results = Array.new() 
			for i in  0..(jump.jumped_pods.length) 
				list = jump.jumped_pods.combination(i).to_a
				for item in list

					new_jump = Jump.new(jump.origin, jump.destination, jump.steps,Array.new(), jump.player)
					unless item.empty? then
						new_jump.set_captures(item.to_a)
					end
					results << new_jump
				end
			end
			return results

		end

		#return array of player's pod locations 
		def find_pods_for_player(player)
			results = []
			@pods.each_with_index do |col, i|
				col.each_with_index do |row, j|	
					
					if @pods[i][j].is_a?(Pod) &&  @pods[i][j].player.index == player.index
						results << Location.new(i,j) #consider returning just location
					end
				end
			end
			return results#.flatten
		end
		
		def other_player(player)
			if player.index == 0
				return @human
			else
				return @comp
			end
		end
		

		def heuristic_value(player)
			#material and position arrays. material relates to games pieces and position relates to position of those pieces 
			#created by the pod count
			#scores are assessed on a per pod basis
			#bonuses are added to material and position to account for special situations 

			material_score = Array.new(@podLocs[player.index].length){0}
			position_score = Array.new(@podLocs[player.index].length){0}
			final_score = 0
			@podLocs[player.index].each_with_index do |loc, idx|
				#1,000 points for each pod
				material_score[idx] += 1000 
				#100 points per prong
				
				#material_score[idx] += (player.prong_reserve*100)
				material_score[idx] += (number_of_prongs(loc)*100) + (player.prong_reserve*100)#number of prongs in reserve should count for something
				#500 points to current pod with friendly pod in adjacent location
				material_score[idx] += (friendly_pod_nearby(loc, player)* 500)

				material_score[idx] += (scoring_position(loc,player)*200)

				material_score[idx] += (opposite_prongs(loc) * 100 ) #(opposite_prongs(loc)*400)

				position_score[idx] += ((7 - new_distance(loc, player))*5000) #500
				#can current pod 
				material_score[idx] += (can_jump_friendly_pod?(loc,player) * 500 )
				#past middle of board?
				material_score[idx] += (middle?(loc, player) ? 100: 0) #400

				total = (0.2*material_score[idx] + 0.15*position_score[idx])
				if total > final_score
					final_score = total
				end
			end
			#puts "m#{material_score}+p#{position_score} = #{(material_score.reduce(:+) + position_score.reduce(:+))}".colorize(:green)
			return final_score
		end

		def middle?(loc, player) 
			if player.index == 0
				if loc.y > 3
					return true
				end
			elsif player.index == 1
				if loc.y < 3
					return true
				end
			end
			return false 
		end
		def can_jump_friendly_pod?(l,player)
			result = 0
			#locations of neighboring pods
			neighbors = Array.new(3) { Array.new(3, false) }
			#current pod
			neighbors[1][1] = 0
			if @pods[l.x][l.y].is_a?(Pod)
				pod = @pods[l.x][l.y]
				neighbors.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if !(i == 1 && j == 1)
							delta_x = i - 1
							delta_y = j - 1
							if is_friendly?(delta_x+l.x, delta_y+l.y, player) 
								delta_i = delta_x*2
								delta_j = delta_y*2
								jump_destination = Location.new(l.x+delta_i, l.y+delta_j) 
								if on_board(jump_destination.x,jump_destination.y) && (@pods[jump_destination.x][jump_destination.y] == nil)
									result += 1
									#debugger
								end
							end
						end
					end
				end
			end
			return result 
		end
		def new_distance(l, player)
			distance_to_base = 100
			dist = distance(l, player, distance_to_base)
			if dist <= distance_to_base
				distance_to_base = dist 
			end
			return dist
		end
		def opposite_prongs(l)
			result = 0
			if @pods[l.x][l.y].is_a?(Pod)
				pod = @pods[l.x][l.y]
				if has_prongs(pod, 0, 0) && has_prongs(pod, 2,2)
					result += 1
				end
				if has_prongs(pod, 1, 0) && has_prongs(pod, 1,2)
					result += 1
				end
				if has_prongs(pod, 2, 0) && has_prongs(pod, 0,2)
					result += 1
				end
				if has_prongs(pod, 0, 1) && has_prongs(pod, 2,1)
					result += 1
				end
			end
			return result
		end
		def scoring_position(l,player) 
			result = 0
			if @pods[l.x][l.y].is_a?(Pod)
				pod = @pods[l.x][l.y]
				pod.prongs.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if has_prongs(pod,i,j) && !(i == 1 && j == 1)
							delta_x = i - 1
							delta_y = j - 1
							#location direction of prong
							d = Location.new(l.x+delta_x, l.y+delta_y)
							while on_board(d.x,d.y) do
								if is_base?(d.x,d.y, other_player(player)) 
									#debugger
									result += 1
								end
								d = Location.new(d.x+delta_x, d.y+delta_y)
							end
						end
					end
				end
			end
			return result
		end
		
		def number_of_prongs(l)
			result = 0
			if @pods[l.x][l.y].is_a?(Pod)
				pod = @pods[l.x][l.y]
				pod.prongs.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if has_prongs(pod, i, j) && !(i == 1 && j == 1)
							result += 1
						end
					end
				end
			end
			return result
		end

		def friendly_pod_nearby(l,player)
			result = 0
			#locations of neighboring pods
			neighbors = Array.new(3) { Array.new(3, false) }
			#current pod
			neighbors[1][1] = 0
			if @pods[l.x][l.y].is_a?(Pod)
				pod = @pods[l.x][l.y]
				neighbors.each_with_index do |col, i|
					col.each_with_index do |row, j|
						if !(i == 1 && j == 1)
							delta_x = i - 1
							delta_y = j - 1
							friend_loc = Location.new(delta_x+l.x, delta_y+l.y)
							if is_friendly?(friend_loc.x,friend_loc.y, player)
								#result += 1
								result += (1+scoring_position(friend_loc, player))
								
							end
						end
					end
				end
			end
			return result
		end


		def heuristic_value_old(player)
			#change variables to rep player vs opponent
			player_number_of_pods = 0

			player_distance_to_base = 100

			player_prongs_on_board = 0
			player_mobility_arr = hops(player).length + jumps(player).length
		
			for l in @podLocs[player.index]
				if @pods[l.x][l.y].is_a?(Pod)
					pod = @pods[l.x][l.y]
					player_number_of_pods = player_number_of_pods + 1
					#return shortest distance aka best option for player
					dist = distance(l, player, player_distance_to_base)
					if dist <= player_distance_to_base 
						 player_distance_to_base = dist
					end

					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							if has_prongs(pod, i, j) && !(i == 1 && j == 1)
								player_prongs_on_board = player_prongs_on_board + 1
							end
						end
					end
				end
			end

			prong_count = player_prongs_on_board #+ player.prong_reserve 
			mobility = player_mobility_arr #- opponent_mobility_arr
			number_of_pods = player_number_of_pods #- opponent_number_of_pods
			
		
			 player_diff_dist = (4 - player_distance_to_base)*(12.5)
			
			total_distance_to_base = player_diff_dist #- opponent_diff_dist
		
			bonus_diff = bonus(player, 0) #- bonus(opponent, 0)
			deduc_diff = deductions(player, 0) #- deductions(opponent, 0)
			val = total_distance_to_base + number_of_pods*(18.825) + prong_count*(0.625) + mobility*(0.125)+ bonus_diff + deduc_diff
				
				if can_score?(player)
					val = 99
				end
			# puts "pdd #{player_diff_dist}".colorize(:red)
			# puts "odd #{opponent_diff_dist}".colorize(:red)
			# puts "total_distance_to_base: #{total_distance_to_base}".colorize(:blue)

			
			# puts "number_of_pods: #{number_of_pods*3}".colorize(:blue)
			# puts "prong_count: #{prong_count*0.625}".colorize(:blue)
			# puts "mobility: #{mobility*0.125}".colorize(:blue)
			# puts "bonus: #{bonus_diff}".colorize(:blue)
			# puts "deductions: #{deduc_diff}".colorize(:blue)
			# puts "result: #{val}".colorize(:red)
			# puts "player: #{player.index}".colorize(:yellow)
			# # # if player_scoring_opp + opponent_scoring_opp != 0
			# # #  	val = player_scoring_opp + opponent_scoring_opp
			# # # end	
		 ##puts "------------------------------------------------"
		 #puts "score:#{val}"
			return val
		end	

		def deductions(curr_player, sub_score)
			count = 0
			opponent = other_player(curr_player)
			for l in @podLocs[curr_player.index]
				if !@podLocs[curr_player.index].include?(l)
					for p in @podLocs[curr_player.index]
						if (p.x - l.x).abs > 2 && (p.y - l.y).abs > 2
							sub_score = sub_score - 1.25
						end
					end
				end
				count = count + 1					
			end

			sub_score = sub_score - 10*(4-count)
			
			for loc in @podLocs[opponent.index]
				for p in @podLocs[curr_player.index]
					pod = @pods[p.x][p.y]
					op = @pods[loc.x][loc.y]

					if loc.x == p.x && op.prong_count > 0  && pod.prong_count < 1
					#	debugger
						sub_score  = sub_score - 1
					end
				end
				
				if !@podLocs[opponent.index].include?(loc)
					for p in @podLocs[curr_player.index]
						pod = @pods[p.x][p.y]
						op = @pods[loc.x][loc.y]
						if loc.x == p.x && op.prong_count > 0  && pod.prong_count < 1

							sub_score  = sub_score - 1
						end

						if (p.x - loc.x).abs > 2 && (p.y - loc.y).abs > 2
							sub_score = sub_score - 1.25
						end
					end
				end
				if curr_player.index == 1
					if loc.y >=3
						sub_score  = sub_score - 0.6
					end
				end
				if curr_player.index == 0
					if loc.y <=3
						sub_score  = sub_score - 0.6
					end
				end
			end

			if can_score?(opponent)
				sub_score = sub_score - 50
			end 
			return sub_score
		end

			
		def bonus(curr_player, bonus_score)
			#debugger
			opponent = other_player(curr_player)

			if can_score?(curr_player)
				bonus_score = bonus_score+20
			#	puts "bs1: #{bonus_score} "
			end
			
			for l_op in @podLocs[opponent.index]
				if @pods[l_op.x][l_op.y].is_a?(Pod)
					pod = @pods[l_op.x][l_op.y]
					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							#if opp has prong
							if has_prongs(pod, i, j) && !(i == 1 && j == 1)
								#does player have prongs on pod at that location?
								for l_c in @podLocs[curr_player.index]
									if l_c.x == l_op.x && @pods[l_c.x][l_c.y].is_a?(Pod)
										c_pod = @pods[l_c.x][l_c.y]
										if c_pod.prong_count > 0
											#puts "bstest2.1:HERE".colorize(:red)
											if curr_player.index == 1 
											 	if has_prongs(c_pod, 1, 0)
													bonus_score = bonus_score + 5
												#	puts "bstest2.1: #{bonus_score} "
												end
											elsif curr_player.index == 0
												if has_prongs(c_pod, 1, 2)
													bonus_score = bonus_score + 5
												#	puts "bstest2.2: #{bonus_score} "
												end
											end
										end
									end 
								end 
							end
						end
					end
				end
			end
			
			for l in @podLocs[curr_player.index]
				if @pods[l.x][l.y].is_a?(Pod)
					pod = @pods[l.x][l.y]
					#proximity to the pod
					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							 if has_prongs(pod, i, j) && !(i == 1 && j == 1)
							 end

							
							if has_prongs(pod, 0, 0) || has_prongs(pod, 2,2)
								if l.x == 4
									bonus_score = bonus_score + 0.25
								#	puts "bs2.1: #{bonus_score} "
								end
								bonus_score = bonus_score + 0.4
							#	puts "bs2: #{bonus_score} "
							end
							if has_prongs(pod, 1, 0) || has_prongs(pod, 1,2)
								bonus_score = bonus_score + 0.5
							#	puts "bs3: #{bonus_score} "
							end
							if has_prongs(pod, 2, 0) || has_prongs(pod, 0,2)
								if l.x == 1
									bonus_score = bonus_score + 0.25
								#	puts "bs4.1: #{bonus_score} "
								end
								bonus_score = bonus_score + 0.4
							#	puts "bs4: #{bonus_score} "
							end
							if has_prongs(pod, 0, 1) || has_prongs(pod, 2,1)
								bonus_score = bonus_score + 0.5
								##puts "bs5: #{bonus_score} "
							end
						
							if curr_player.index == 1 
							
								if l.y <= 3
									bonus_score = bonus_score + 0.6
									#puts "bs7: #{bonus_score} "
								end
							
							 	if has_prongs(pod, 1, 0)
									bonus_score = bonus_score + 0.25
								#	puts "bs8: #{bonus_score} "
								end
							elsif curr_player.index == 0
							
								if l.y >= 3
									bonus_score = bonus_score + 0.6
								#	 puts "bs10: #{bonus_score} "
								end
								if has_prongs(pod, 1, 2)
								#	bonus_score = bonus_score + 0.25
								#	puts "bs11: #{bonus_score} "
								end
							end
						end
					end
				end
			end
			return bonus_score 
		end
		#Params
			#l = pod location
			#player = current player
			#distance_to_base = current distance_to_base
		def distance(l, player, distance_to_base)
	 	#Calculates distance to opponent's base
			for base in player.opponent_bases
				dist = Math.sqrt( (base.y - l.y)**2 )	
				if dist < distance_to_base
					distance_to_base = dist
				end
			end

			return distance_to_base	
		end
		#return new location if true or initial location if false
		#can score function (add jumps later)
		def can_score?(curr_player)
			opponent = other_player(curr_player)
			
			for l in @podLocs[curr_player.index]
				if @pods[l.x][l.y].is_a?(Pod)
					pod = @pods[l.x][l.y]
					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							if has_prongs(pod, i, j) && !(i == 1 && j == 1)
								delta_x = i-1
								delta_y = j-1
								d = Location.new(l.x+delta_x, l.y+delta_y) # destination
								if on_board(d.x,d.y) && (@pods[d.x][d.y] == nil) && ( is_base?(d.x, d.y, opponent) )
									return true
								end
							end
						end
					end
				end 
			end 
			return false 
		end
		#are these coordinates a base?
		def is_base?(x,y, curr_player)
			#puts "hERE #{curr_player.bases}"
			curr_player.bases.each do |l|
				if l.x == x && l.y == y
					return true
				end 
			end 
			return false
		end
		def is_friendly?(x,y, curr_player)
			#return true if given coordinates relate to a friendly pod 
			if @pods[x][y].is_a?(Pod)
				@podLocs[curr_player.index].each do |l|
					if l.x == x && l.y == y
						return true
					end 
				end 
			end
			return false
		end

		def game_ended?(player)
			if  end_value(player) != nil
				return true
			else
				return false
			end
		end

		def end_value(player)
			@podLocs[player.index].each do |pod| 
				player.opponent_bases.each do |base|
					if pod.x == base.x && pod.y == base.y
						return 500000
					end
				end
			end
			return nil			
		end
	end
end