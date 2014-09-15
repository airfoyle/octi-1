module Octi
	class Player 
          @@computer_index = 0;
          @@opponent_index = 1;

		attr_reader :comp, :human, :index
		def initialize(i, reserve)
			@index = i
			@prong_reserve = reserve
		end

		def index
			return @index
		end

		def prong_reserve
			return @prong_reserve
		end
		def set_prong_reserve(n)
			@prong_reserve = n
		end

		def better_for(v1, v2)
			#puts "index: #{@index} | v1 = #{v1}| v2 = #{v2} "
			if @index == @@computer_index 
                          return (v1 > v2)
			else
                          return (v1 < v2)
			end
		end

		def worst_value
			if @index == @@computer_index
                          -500000
			else
                          500000
			end
		end

		def set_bases(bases)
			@bases = bases
		end

		def bases
			return @bases
		end
		
		def set_opponent_bases(bases)
			@opponent_bases = bases
		end

		def opponent_bases
			return @opponent_bases
		end

                def id_string()
                  if index == @@computer_index then "Comptuter" else "Opponent" end
                end

                def to_s()
                  "{#{id_string()}}"
                end
	end
end
