module Octi
	class Move
		attr_accessor :pod, :prongs, :board, :game_state

		def initialize(board,position)
			@board = board
			@x = position[0]
			@y = position[1]
			#@pod = position[0] #pod
			@origin= @board[@x][@y]
			@destination = @origin
 		end


		def make
		end
	end

	class Insert < Move
		attr_accessor :pod, :prongs, :inserts
		def initialize(game_state,position)
			super
		end

		def make(x,y)
			if !@origin.prongs[x][y]
				@origin.prongs[x][y] = true
				return self					
			end
		end

	# class Insert < Move
	# 	attr_accessor :pod, :prongs, :inserts
	# 	def initialize(game_state,position)
	# 		super
	# 	end

	# 	def make(x,y)
	# 		if !@origin.prongs[x][y]
	# 			@origin.prongs[x][y] = true
	# 			return self					
	# 		end
	# 	end
=begin
		def make
			super
			@origin.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|
					if !@origin.prongs[i][j]
							@origin.prongs[i][j] = true
							@inserts << self
							return self					
					end
				end
			end	
			#add moves to GS.moves?
			# game_state.moves << @inserts
			# return @inserts
		end	
=end
	end

	class Hop < Move
		attr_accessor :pod, :prongs, :board
		def initialize(game_state,position)
			super
		end

		def make(i,j)
			if @origin.prongs[i][j]
				if ((0..5)===(@x+i) && (0..6)===(@y+j) && @board[@x+i][@y+j] == nil)
					#make move here
					@destination = @board[@x+i][@y+j]
					#@origin = @destination
					position[0] = @x+i
					position[1] = @y+j
					return self
				end
			end
		end

=begin
		def make(game_state, position)
			super
			@origin.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|	
					if @origin.prongs[i][j]
						if ((0..5)===(@x+i) && (0..6)===(@y+j) && @board[@x+i][@y+j] == nil)
							#make move here
							new_move = self.dup
							@destination = @board[@x+i][@y+j]
							@origin = @destination
							position[0] = @origin
							position[1] = @x+i
							position[2] = @y+j
							@hops << self
							#new_move = Hop.new.make(game_state,position)
						end
					end
				end
			end	
			game_state.moves << @hops
			return @hops		
		end
=end	

	end

	class Jump < Move
		attr_accessor :pod, :prongs, :board
		def initialize
			@jumped_pods = []
			@jump_sequence = []
		end

		def make(i,j)
			if @origin.prongs[i][j] && ((0..5)===(@x+2*i) && (0..6)===(@y+2*j))
				if @board[@x+i][@y+j].is_a?(Pod) && @board[@x+2*i][@y+2*j] == nil
					@jumped_pods << board[@x+i][@y+j]
					@destination = 	board[@x+2*i][@y+2*j] #completes jump object with origin and destination
					#@origin = @destination 
					position[0] = @x+2*i
					position[1] = @y+2*j
					#recursion
					# @jump_sequence << self 
					# new_move = Jump.new.make(game_state,position)
				end
			end
		end
=begin
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
							position[2] = @y+2*j
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

=end	
	end	

end
