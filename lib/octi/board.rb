module Octi

	# 	def initialize 
	# 		row = {
	# 	        "1" => nil,
	# 	        "2" => nil,
	# 	        "3" => nil,
	# 	        "4" => nil,
	# 	        "5" => nil,
	# 	        "6" => nil,
	# 	        "7" => nil				
	# 		}
	# 		@board = {
	# 			1 => row.dup,
	# 	        2 => row.dup,
	# 	        3 => row.dup,
	# 	        4 => row.dup,
	# 	        5 => row.dup,
	# 	        6 => row.dup
	# 		}
	# end



# 	class Board
# 		attr_reader :hash

# 		def initialize
# 			@hash = {}
# 		end

# 		def [](key)
# 			hash[key] ||= {}
# 		end

# 		def rows
# 			hash.length   
# 		end

# 		alias_method :length, :rows

# 		def make_base() # make a cell a base

# 	end
# end 

#@board = Board.new

#@board[6][7]

=begin
	
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

	