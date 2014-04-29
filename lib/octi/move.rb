module Octi
	class Move
		def initialize(board,position)
			@board = board
			@x = position[0]
			@y = position[1]
			@jumped = []
 		end


		def can_move?(board, x, y)
			count = -1
			for i in -1..1
				for j in -1..1
					count++
					if (i&&j) == 0
						next
					elsif ((0..5)===(x+i) && (0..6)===(y+j)) #on board
						if (@board[x][y].prongs[count]  && @board[x+i][y+j] ==nil)
							return true #create a hop move
						else 
							chain = []
							can_jump?(board, x, y, chain)
							#create pong insertion move	
							#@board[x][y].prongs[count] = true
							#WHAT NOW??
						end
					end
				end
			end
		end

		
		def can_jump?(board, x,y,chain)
			#is there a prong? --from can_move?
			#is there a pod to jump over --from can_move?
			#is cell after pod nil? -- logic below
			count = -1
			for i in -1..1
				for j in -1..1
					count++
					if (i&&j) == 0
						next
					elsif ((0..5)===(x+i) && (0..6)===(y+j)) && @board[x][y].prongs[count]#on board
						if (@board[x+2*i][y+2*j] ==nil && (@board[x+i][y+j]).is_a?(Pod))
							chain << @board[x+i][y+j]
							can_jump?(board, x+2*i, y+2*i, chain)
							#create jump move
							#can_jump?(@board, x+i, y+j, chain)
						else 
							@jumped << chain
						end
					else
						@jumped << chain
					end
				end
			end
		end
		
		def make
		end
	end


	class Insert < Move
	end

	class Hop < Move
	end

	class Jump < Move
	end	
end
