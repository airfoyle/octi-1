module Octi
	class GameTree

		attr_accessor :comp

		def generate
		

			initial_game_state = GameState.new(comp, @board = Board.new(6,7))
			generate_moves(initial_game_state)
			initial_game_state
	end

	def generate_moves(game_state)
		next_player = (game_state.current_player == comp ? human : comp)
		game_state.board.each_index do |x|
			x.each_with_index do |game_state.current_player, position|
			unless player_at_position #base case placeholder

				if game_state.board
				game_state.current_player.pods.each do |pod|
					pod.prongs.each do |prong|
						prong ? prong = false : prong = true
						next_board = game_state.board.dup
						next_board[position] = #game_state.current_player

					end
				end

				#if prong exists
				next_board = game_state.board.dup
				#next_board[position] = game_state.current_player

				next_game_state = (GameState.cache.states[next_baord] ||= GameState.new(next_player, next_board)))
				game_state.moves << next_game_state
				generate_moves(next_game_state)
			end
		end
	end
end