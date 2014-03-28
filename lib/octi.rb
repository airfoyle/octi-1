class Game
	def initialize(width, height)
		@width = width
		@height = height

		@board = Array.new(height) { |row| 
			Array.new(width) { |col|
				false 
			}	
		}
	end
end

class Pod
	def initialize(color)
		@color = color
		@prongs = Array.new(8, false)
	end
end

class play
	def initialize(self)
		print("Welcome to OCTI!")
		print("Now starting a new game...")
		self.run_game(Game())
	end

	def run_game(self, game)
		while(1)
			print()
			game.print_board()

			move = input("Please enter a move: ")

			if move == 'q'
				move = input("Quit?" + "Y/N")
				if move == 'n'
					next

			game.do_move(move)
		end
	end
end

#validate position strings
#return x & y coordinates 
class Position
	class OutOfBoundsError < StandardError; end
	class BadArgumentError < StandardError; end

	VALID_COLUMNS = %w[a b c d e f]
	VALID_ROWS = [1, 2, 3, 4, 5, 6, 7]

	 ERRORS = {
      :bad_column => 'Column out of bounds. Columns must be in the range a through h.',
      :bad_row => 'Row out of bounds. Rows must be in the range 1 through 8.',
      :bad_argument => 'You must supply a two character position string, like this: Chess::Position.new("a4")'
    }


