module Octi
	class GameTree

		attr_accessor :comp, :human, :positions, :comp_pos, :board, :inserts,:pod
		
		def initialize
		end

		def generate
			initial_game_state = GameState.new(@comp = Player.new(0),@human = Player.new(1), @board = Board.new(6,7))			
			generate_moves(initial_game_state)
			#next_game_state = GameState.new(@comp,@human, Board.new(6,7))
			#test(next_game_state)
		end

		def generate_moves(game_state)
			
			
			# inserts = []
			# hops = []
			# jump_seq = []
			# for position in game_state.board.comp.positions
			# 	generate_inserts(game_state, position, inserts)
			# 	#generate_hops(game_state, position, hops)
			# 	#generate_hops(game_state, position, jump_seq)
			# 	break
			# end
		end

		def test(next_game_state)
			generate_moves(next_game_state)
		end


		def generate_inserts(game_state, position, results)
			pod = game_state.board.board[position[0]][position[1]]
			pod.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|
					new_b = Board.new(6,7)
					val = Insert.new(new_b.board, position).make(i,j)
					val ? results << val : next

				end
			end
		end
		def generate_hops(game_state, position, results)
			pod = game_state.board.board[position[0]][position[1]]
			pod.prongs.each_with_index do |row, i|
				row.each_with_index do |col, j|
					new_b = Board.new(6,7)
					val = Hop.new(new_b.board, position).make(i,j)
					val ? results << val : next
				end
			end
		end	
		def generate_jumps(game_state, position, results)
			pod = game_state.board.board[position[0]][position[1]]
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
end

