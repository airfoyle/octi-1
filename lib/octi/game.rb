module Octi
	class Game
		def initialize
			@ui = UserInterface.new
			@comp = Player.new(0)
			@human = Player.new(1)
			board = Board.new(6,7, @comp, @human)
			@initial_position = Position.new(board)
			game_tree = GameTree.new(@initial_position)

			@ui.print_message("Welcome to OCTI!")
			run(@initial_position)
		end

		def run(position)
			if position.game_ended?
				puts winner(position.end_value)
			else
				puts "Your options ..."
				turn(@human, position)
				#turn(@comp)
				#run(position) 
			end
		end

		def turn(player, position)
			if player.index == 0
				#
			elsif player.index == 1
				options_prompt = get_options(position)
				move_choice = @ui.get_input(options_prompt.print_options) 
				list = options_prompt.choose_key(move_choice.to_i) #print n forms of move_choice
				#final choice = options_prompt. #select final move for execution
			end
		end

		def get_options(position)
			all = position.legal_moves(@human)
			#return options
			oh = OptionHash.new(all)
			return oh
		end

		def winner(value)
			if value == 100
				puts "GAME OVER. You lost :("
			elsif value == -100
				puts "You won!"
			else
				puts "Error"
			end

		end
	end
end