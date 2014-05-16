module Octi
	class GameTree

		attr_accessor :comp, :human, :positions, :comp_pos, :board, :inserts,:pod
		
		def initialize(board_position)

		end

		# def generate
		# 	initial_game_state = GameState.new(@comp = Player.new(0),@human = Player.new(1), @board = Board.new(6,7))			
		# end


### MINIMAX ALGO ###
		def minimax (position, depth)
			return maxmove(position, depth)
		end

		def maxmove (position, depth)
			if position.game_ended? || depth == 0
				return value(position)
			else
				best_move = nil #+infinity?
				moves = position.legal_moves(@comp) #children
				for move in moves
					new_move = minmove(move.execute_move(position, depth -1))
					if value(move) > value(best_move)
						best_move = move
					end
				end
				return best_move
			end
		end

		def minmove(position)
			best_move = nil #-infinity?
			moves = position.legal_moves(@human)
			for move in moves
				new_move = maxmove(move.execute_move(position))
				if value(move) > value(best_move)
					best_move = move
				end 
			end
			return best_move
		end

		#heuristic evaluation function
		def value(position)
			
			#distance to base
			pods = position.pods
			podlocs = position.podLocs
			
			for l in podlocs[@comp.index]

			end

			#number of pods
			position.pods
			#prongs in reserve 
			#prongs on board
			comp_count = 0
			human_count = 0
			for l in podlocs[@comp.index]
				if pods[l.x][l.y].is_a?(Pod)
					comp_count++
				end
			end
			for l in podlocs[@human.index]
				if pods[l.x][l.y].is_a?(Pod)
					human_count++
				end
			end
			pod_count = comp_count - human_count	
				#prong count

			#prong distribution -mobility

			return distance_to_base + number_of_pods + prong_count + mobility
			#				
		end	

		def prongs_board(pods, podlocs)
					
		end		
	end
end

