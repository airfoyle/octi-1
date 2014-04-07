module Octi
	class GameTree
		def generate
			initial_game_state = GameState.new('B', Array.new(42))
			generate_moves(initial_game_state)
			initial_game_state
	end

	def generate_moves(game_state)
		next_player = (game_state.current_player == 'B' ? 'R' : 'B')
		game_state.board.each_with_index do |player_at_position, position|
			unless player_at_position
				next_board = game_state.board.dup
				next_board[position] = game_state.current_player

				next_game_state = (GameState.cache.states[next_baord] ||= GameState.new(next_player, next_board)))
				game_state.moves << next_game_state
				generate_moves(next_game_state)
end