module Octi
	class Location
		@@board_height = 7
                @@board_width = 6
		def initialize(x,y)
                  if x<0 || x >= board_width || y<0 || y > @@board_height
                    raise ArgumentError.new("Bad args (#{x.to_s}#{y.to_s}) to"
                                            + " Location.new")
                  else
                    @x = x
                    @y = y
                  end
		end

		def x
			return @x
		end

		def y
			return @y
		end

                def board_height
                  return @@board_height
                end

                def board_width
                  return @@board_width
                end

		def pretty_string
                  return (@x+1).to_s + (@@board_height - @y).to_s
                end

                def to_s()
                  "{Location " + @x.to_s + "," + @y.to_s + "}"
                end

                # Given a string of length 2, deprettify it
                def self.from_string(s)
                  c = s.codepoints
                  z = '0'.codepoints[0]
                  col = c[0] - z;
                  row = c[1] - z;
                  return Location.new(col - 1, @@board_height - row)
                end                  
	end

end
