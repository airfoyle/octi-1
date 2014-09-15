module Octi
	class Pod
		attr_reader :player,:prongs

                # For translating pairs of offsets to standard peg letters
		@@direction = Array.new(3) { Array.new(3) }
                @@direction[0][0] = "H"  #:Northwest
                @@direction[1][0] = "A"  #:North
                @@direction[2][0] = "B"  #:Northeast
                @@direction[0][1] = "G"  #:West
                @@direction[1][1] = nil  #: Illegal
                @@direction[2][1] = "C"  #:East
                @@direction[0][2] = "F"  #:Southwest
                @@direction[1][2] = "E"  #:South
                @@direction[2][2] = "D"  #:Southeast
                for i in (0..2)
                   freeze @@direction[i]
                end
                freeze @@direction

                # For translating the other way (letter already translated to number, A = 0)
                # To make coordinates match the subscripts above, add 1
                @@offset = Array.new(9)
                @@offset[0] = [0,-1]
                @@offset[1] = [1,1]
                @@offset[2] = [1,0]
                @@offset[3] = [1,1]
                @@offset[4] = [0,1]
                @@offset[5] = [-1,1]
                @@offset[6] = [-1,0]
                @@offset[7] = [-1,-1]
                freeze(offset)

                # Check 
                for i in (0..7)
                  off = @@offset[i]
                  if (@@direction[off[0] + 1, off[1] + 1] != i)
                    raise ArgumentError("@@direction doesn't match @@offset for prong #{i}")
                end

		def initialize(player)
			@prongs = Array.new(3) { Array.new(3, false) }
			@prongs[1][1] = 0
			@player = player
		end


                def self.direction()
                  return @@direction
                end

                def self.offset()
                  return @@offset
                end

		def player
			return @player
		end

		def set_prongs(n)

			@prongs = n
		end

		def prong_count
			count = 0 
			for prong in @prongs
				if prong && prong != 0
					count = count+1
				end
			end
			return count
		end
		
		def print_prongs
			@prongs.each_with_index do |col, i|
				col.each_with_index do |row, j|
					if @prongs[i][j] == true && !(i == 1 && j == 1)
						puts "(#{i}, #{j})"
					end
				end
			end
		end

                def prong_string()
                  "ABCDEFGH".each_char.select{ |c| filled(c.ord - 'A'.ord)}
                end

                def filled(prongnum)
                  off = @@offset(prongnum)
                  prongs[off[0] + 1, off[1] + 1]
                end

                def to_s()
                  "{Pod owner #{@player.id_string()};  type (#{prong_string()})}"
                end
	end
end

