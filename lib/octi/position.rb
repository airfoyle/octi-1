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
							delta_x = i -1
							delta_y = j-1
							#delta_i = delta_x + 1
							#delta_j = delta_y + 1
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

			jumped = []
			jumps = []
			avoid = []
			for l in @podLocs[player.index]
				pod = @pods[l.x][l.y]
				avoid << l
				a_jump = jumpy(pod, jumped, l,l, player, avoid)
				#puts "J:end of recursion:#{a_jump}"
				if !a_jump.empty?
					jumps << a_jump
					#puts "#{jumps}"
				end
			end

			return jumps.flatten
		end

		def jumpy(pod, jumped_p, s, c, player, avoid)
			results = Array.new
			
			
			pod.prongs.each_with_index do |col, i|
				col.each_with_index do |row, j|
					if has_prongs(pod,i,j) && !(i == 1 && j == 1)
						#debugger
						delta_x = i -1
						delta_y = j-1
						delta_i = delta_x*2
						delta_j = delta_y*2
						d = Location.new(c.x+delta_i, c.y+delta_j) #d = destination 
						pod_loc = Location.new(c.x+delta_x, c.y+delta_y) #c = captured pod

						#destination is on board and pod is being jumped to get to destination
						if on_board(d.x, d.y) && @pods[pod_loc.x][pod_loc.y].is_a?(Pod) && (@pods[d.x][d.y] == nil) && !avoid_loc(pod_loc, avoid)
							
							#puts "J:pod:#{pod}|j_p:#{jumped_p}|s:#{s}|c:#{c}|p: #{player}|a:#{avoid}".colorize(:red)
						
							#puts "here".colorize(:red)
							#from is origin before jump sequence
							from = Location.new(s.x,s.y)
							
							#to is a jump destination in sequence
							to = Location.new(d.x,d.y) 

							#player can jump opponent's pods and his own pods

							if pod_loc.x ==s.x && pod_loc.y ==s.y
								puts "HERE!!!".colorize(:red)
							end

							jumped_p << pod_loc
							avoid << pod_loc 

							for l in jumped_p
								if !@pods[l.x][l.y].is_a?(Pod)
									jumped_p.delete(l)
									#puts "GOTCHA!"
								end
							end


							results << captured(Jump.new(from, to, jumped_p, player))
							
							#results << Jump.new(from, to, jumped_p, player)

							#results << 
							#jumpy(pod, jumped_p, s, d, player)

							#results << 
							jumpy(pod, jumped_p, s, d, player, avoid)
						end
					end
				end
			end
			return results.flatten#results.flatten
		end
		
		#check if pod should be avoided
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
			for i in  0..(jump.jumped_pods.length+1) 
				list = jump.jumped_pods.combination(i).to_a
				for item in list
					new_jump = Jump.new(jump.origin, jump.destination, Array.new(), jump.player)
					new_jump.set_captures(item.to_a)
					results << new_jump
				end

				#puts "combos:#{jump.jumped_pods.combination(i).to_a }"
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
			#change variables to rep player vs opponent
			opponent =  self.other_player(player)
			player_number_of_pods = 0
			opponent_number_of_pods = 0
			
			player_distance_to_base = 100
			opponent_distance_to_base = 100

			player_prongs_on_board = 0
			opponent_prongs_on_board = 0
			player_mobility_arr = hops(player).length #+ jumps(player).length
			opponent_mobility_arr = hops(opponent).length #+ jumps(opponent).length

			player_scoring_opp = 0
			opponent_scoring_opp = 0

			player_bonus = 0

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
							if player_distance_to_base ==1 
								for base in player.opponent_bases
									if (l.x+i == base.x && l.y+j == base.y) && @pods[base.x][base.y] == nil
										#immediate scoring oop
										#player_scoring_opp = 99
									end
								end
							end
						end
					end
				end
			end
			
			for l in @podLocs[opponent.index]
				if @pods[l.x][l.y].is_a?(Pod)
					pod = @pods[l.x][l.y]
					opponent_number_of_pods = opponent_number_of_pods + 1
					
					dist = distance(l, opponent, opponent_distance_to_base)
					if dist <= opponent_distance_to_base 
						 opponent_distance_to_base = dist
					end
					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							if has_prongs(pod, i, j) && !(i == 1 && j == 1)
								opponent_prongs_on_board = opponent_prongs_on_board+1
							end
							if opponent_distance_to_base ==1 
								for base in opponent.opponent_bases
									if l.x+i == base.x && l.y+j == base.y && @pods[base.x][base.y] == nil
										#immediate scoring oop
										#opponent_scoring_opp = -99 
									end
								end
							end
						end
					end
				end
			end
		#	debugger
=begin
		puts "heuristics: p:#{player.index}| o: #{opponent.index}".colorize(:blue)
		puts "player.prong_reserve #{player.prong_reserve}".colorize(:blue)
		puts "opponent.prong_reserve #{opponent.prong_reserve}".colorize(:blue)
		puts "player_prongs_on_board  #{player_prongs_on_board }".colorize(:blue)
		puts "opponent_prongs_on_board #{opponent_prongs_on_board}".colorize(:blue)
		puts "player_mobility #{player_mobility_arr}".colorize(:blue)
		puts "opponent_mobility #{opponent_mobility_arr}".colorize(:blue)
		puts "player_number_of_pods #{player_number_of_pods}".colorize(:blue)
		puts "opponent_number_of_pods #{opponent_number_of_pods}".colorize(:blue)
		puts "player_distance_to_base #{player_distance_to_base}".colorize(:blue)
		puts "opponent_distance_to_base #{opponent_distance_to_base}".colorize(:blue)
		puts "player prongs: #{player.prong_reserve}"
		puts "opponent prongs: #{opponent.prong_reserve}"
=end
			#prong_count = (player.prong_reserve - opponent.prong_reserve ) + (player_prongs_on_board - opponent_prongs_on_board)
			prong_count = player_prongs_on_board #+ player.prong_reserve 
			mobility = player_mobility_arr #- opponent_mobility_arr
			number_of_pods = player_number_of_pods #- opponent_number_of_pods
			
		
			 player_diff_dist = (4 - player_distance_to_base)*(12.5)
			 opponent_diff_dist = (4 - opponent_distance_to_base)*(12.5)
			
			total_distance_to_base = player_diff_dist #- opponent_diff_dist
			
			#total_distance_to_base = player_distance_to_base - opponent_distance_to_base
		
			# if total_distance_to_base < 0
			# 	total_distance_to_base = 5*(total_distance_to_base.abs) 
			# elsif total_distance_to_base > 0
			# 	total_distance_to_base = -5*total_distance_to_base
			# end 
		
			bonus_diff = bonus(player, 0) #- bonus(opponent, 0)
			deduc_diff = deductions(player, 0) #- deductions(opponent, 0)
			val = total_distance_to_base + number_of_pods*(2.5) + prong_count*(0.0625) + mobility*(0.125)+ bonus_diff + deduc_diff

			# puts "pdd #{player_diff_dist}".colorize(:red)
			# puts "odd #{opponent_diff_dist}".colorize(:red)
			# puts "total_distance_to_base: #{total_distance_to_base}".colorize(:blue)

			
			# puts "number_of_pods: #{number_of_pods*2.5}".colorize(:blue)
			# puts "prong_count: #{prong_count*0.0625}".colorize(:blue)
			# puts "mobility: #{mobility*0.125}".colorize(:blue)
			# puts "bonus: #{bonus_diff}".colorize(:blue)
			# puts "deductions: #{deduc_diff}".colorize(:blue)
			# puts "result: #{val}".colorize(:red)
			# puts "player: #{player.index}".colorize(:yellow)
			# # if player_scoring_opp + opponent_scoring_opp != 0
			# #  	val = player_scoring_opp + opponent_scoring_opp
			# # end	
		 #puts "------------------------------------------------"

			return val
		end	

		def deductions(curr_player, sub_score)
			count = 0
			for l in @podLocs[curr_player.index]
				# if @pods[l.x][l.y].is_a?(Pod)
				# 	#if oppornent is about to score
				# 	base_y = curr_player.bases.first.y-1
				# 	for pod in @podLocs[other_player(curr_player).index]
				# 		if pod.y == base_y
				# 			sub_score = sub_score - 1.25
				# 		end
				# 	end
				# end
				count = count+1
			end
			sub_score = sub_score - 10*(4-count)
			opponent = other_player(curr_player)
			if can_score?(opponent)
				sub_score = sub_score - 50
			end 
			return sub_score
		end

		def bonus(curr_player, bonus_score)
			#debugger
			
			if can_score?(curr_player)
				bonus_score = bonus_score+25
			#	puts "bs1: #{bonus_score} "
			end
			for l in @podLocs[curr_player.index]
				if @pods[l.x][l.y].is_a?(Pod)
					pod = @pods[l.x][l.y]
					
					pod.prongs.each_with_index do |col, i|
						col.each_with_index do |row, j|
							# if has_prongs(pod, i, j) && !(i == 1 && j == 1)
							# 	delta_x = i -1
							# 	delta_y = j-1
							# 	d = Location.new(l.x+delta_x, l.y+delta_y) # destination
							# 	#&& d.x and d.y are bases
							# 	other_player(curr_player).opponent_bases.each do |o_base|
							# 		if on_board(d.x,d.y) && (d.x == o_base.x && d.y == o_base.y)
							# 			bonus_score = bonus_score +12.5
							# 		end
							# 	end
							# end

							if has_prongs(pod, 0, 0) && has_prongs(pod, 2,2)
								bonus_score = bonus_score + 0.5
								#puts "bs2: #{bonus_score} "
							end
							if has_prongs(pod, 1, 0) && has_prongs(pod, 1,2)
								bonus_score = bonus_score + 0.5
								#puts "bs3: #{bonus_score} "
							end
							if has_prongs(pod, 2, 0) && has_prongs(pod, 0,2)
								bonus_score = bonus_score + 0.5
							#	puts "bs4: #{bonus_score} "
							end
							if has_prongs(pod, 0, 1) && has_prongs(pod, 2,1)
								bonus_score = bonus_score + 0.5
							#	puts "bs5: #{bonus_score} "
							end
						
							if curr_player.index == 1 
								if l.y == 3
									bonus_score = bonus_score + 0.5
								#	puts "bs6: #{bonus_score} "
								end
								if l.y < 3
									bonus_score = bonus_score + 0.5
								#	puts "bs7: #{bonus_score} "
								end
							
							 	if has_prongs(pod, 1, 0)
									bonus_score = bonus_score + 0.25
								#	puts "bs8: #{bonus_score} "
								end
							elsif curr_player.index == 0
								if l.y == 3
									bonus_score = bonus_score + 0.5
								#	puts "bs9: #{bonus_score} "
								end
								if l.y > 3
									bonus_score = bonus_score + 0.5
								#	 puts "bs10: #{bonus_score} "
								end
								if has_prongs(pod, 1, 2)
									bonus_score = bonus_score + 0.25
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
				# if @pods[l.x][l.y].is_a?(Pod) 
				# 	pod = @pods[l.x][l.y]
				# end
				# pod.prongs.each_with_index do |col, i|
				# 	col.each_with_index do |row, j|
				# 		if has_prongs(pod, i, j) && !(i == 1 && j == 1)
				# 			delta_x = i -1
				# 			delta_y = j-1
				# 			d = Location.new(l.x+delta_x, l.y+delta_y) # destination
				# 			if (on_board(d.x,d.y) && @pods[d.x][d.y] == nil)
				# 				#l = Location.new(d.x,d.y)
				# 				dist = Math.sqrt( (base.x - d.x)**2 + (base.y - d.y)**2 )
				# 				if dist < distance_to_base
				# 					distance_to_base = dist
				# 				end
				# 			else
				# 				dist = Math.sqrt( (base.x - l.x)**2 + (base.y - l.y)**2 )
				# 				if dist < distance_to_base
				# 					distance_to_base = dist
				# 				end
				# 			end
				# 		end 
				# 	end 
				# end 
			#dist = Math.sqrt( (base.x - l.x)**2 + (base.y - l.y)**2 )
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
		
		def game_ended?(player)
			if (val = end_value(player)) != nil
				#puts "val= #{val}".colorize(:blue)
				return true
			else
				return false
			end
		end

		def end_value(player)
	
			@podLocs[player.index].each do |pod| 
				player.opponent_bases.each do |base|
					if pod.x == base.x && pod.y == base.y
						return 100
					end
				end
			end
			# @podLocs[other_player(player).index].each do |pod| 
			# 	other_player(player).opponent_bases.each do |base|
			# 		if pod.x == base.x && pod.y == base.y
			# 			return -100
			# 		end
			# 	end
			# end
			
			return nil
			
		end
	end
end