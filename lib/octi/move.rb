module Octi
	class Move
		attr_accessor :pod, :prongs, :board, :game_state

		def initialize
 		end

 		def make(game_state,position)
			@game_state = game_state
			@board = game_state.board.board
			@x = position[1]
			@y = position[2]
			#@pod = position[0] #pod
			@origin= @board[@x][@y]
			@destination = @origin
		end

=begin
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
					if ((i&&j) == 0)
						next
					elsif ((0..5)===(x+i) && (0..6)===(y+j)) && @board[x][y].prongs[count]#on board
						if (@board[x+2*i][y+2*j] ==nil && (@board[x+i][y+j]).is_a?(Pod))
							chain << @board[x+i][y+j]
							can_jump?(board, x+2*i, y+2*i, chain) #can jump from new position
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
=end	

	end


	class Insert < Move
		attr_accessor :pod, :prongs, :inserts
		def initialize
			@inserts = []
		end
		def make(game_state, position)
			super
			@origin.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|		
					if !@origin.prongs[i][j]
							@origin.prongs[i][j] = true
							@inserts << self

							new_move = Insert.new.make(game_state,position)
					end
				end
			end	
			#add moves to GS.moves?
			game_state.moves << @inserts
			return @inserts
		end	
	end

	class Hop < Move
		attr_accessor :pod, :prongs, :board
		def initialize
			@hops = []
		end

		def make(game_state, position)
			super
			@origin.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|	
					if @origin.prongs[i][j]
						if ((0..5)===(@x+i) && (0..6)===(@y+j) && @board[@x+i][@y+j] == nil)
							#make move here
							@destination = @board[@x+i][@y+j]
							@origin = @destination
							position[0] = @origin
							position[1] = @x+i
							position[1] = @y+j
							@hops << self
							new_move = Hop.new.make(game_state,position)
						end
					end
				end
			end	
			game_state.moves << @hops
			return @hops		
		end
	end

	class Jump < Move
		def initialize(board, position)
			@jumped_pods = []
			@jump_sequence = []
		end

		def make(game_state, position)
			super
			@origin.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|	
					if @origin.prongs[i][j] && ((0..5)===(@x+2*i) && (0..6)===(@y+2*j))
						if @board[@x+i][@y+j].is_a?(Pod) && @board[@x+2*i][@y+2*j] == nil
							@jumped_pods << board[@x+i][@y+j]
							@destination = 	board[@x+2*i][@y+2*j] #completes jump object with origin and destination
							@origin = @destination 
							position[0] = @origin
							position[1] = @x+2*i
							position[1] = @y+2*j
							#recursion
							@jump_sequence << self 
							new_move = Jump.new.make(game_state,position)
						end
					end
				end
			end
			game_state.moves << @jump_sequence
			return @jump_sequence
		end		
	end	

end
