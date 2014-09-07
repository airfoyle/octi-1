module Octi
	class Game
		@@count = 1
		attr_reader :board_obj
		def initialize
			@ui = UserInterface.new
			@comp = Player.new(0, 12)

			@human = Player.new(1, 12)
			@board_obj = Board.new(6,7, @comp, @human)
			@initial_position = Position.new(@board_obj.board, @comp, @human)

			@moves_made = Array.new(2) { Array.new() }

			@ui.print_message("Welcome to OCTI!")
			run(@initial_position, @human)
		end

		def run(current_position, player_to_move)
			
			if current_position.game_ended?(player_to_move)
				puts "#{current_position.heuristic_value(player_to_move)}".colorize(:red)
			 winner(current_position.end_value(player_to_move), player_to_move, current_position)
			else
				
				next_move = turn(player_to_move, current_position, @@count)
				#@moves_made[player_to_move.index].push(next_move)
				#puts "move->#{next_move} ".colorize(:green)
				if next_move != nil
					c_p = next_move.execute_move(current_position)
					current_position = c_p
					 winner(current_position.end_value(player_to_move), player_to_move, current_position)
				end 
				run(current_position, current_position.other_player(player_to_move)) 
			end
		end
		
		def bestmove(position, player, depth)
			#puts "Entering bestmove[depth: #{depth}]".colorize(:blue)
			if position.game_ended?(player)	

			#	puts "G_O:depth:#{depth}, p:#{player.index}, #{position.end_value(player)}, #{position.heuristic_value(player)}".colorize(:green)
			  return nil, position.end_value(player)	
			elsif depth == 0
			  return nil, position.heuristic_value(player)
			else
				best_move = nil
				best_value = player.worst_value		
				moves = position.legal_moves(player).flatten
				for move in moves
				    new_move, move_value = bestmove(move.execute_move(position),
				             position.other_player(player), 
				             depth - 1)
				    if best_move == nil || player.better_for(move_value, best_value)
				    #	puts "BM: #{new_move}"
				            best_move = move
				            best_value = move_value
				    end
				end
				return print_bestmove(best_move, best_value, depth, player,position)
	        end
	    end	
	    
	    def print_bestmove(m, v, d, p,position)
	   		position.game_ended?(p)
	   		#puts "exit bm score: #{v}|move #{m}|d:#{d}|p:#{p.index}".colorize(:red)
	    	return m,v
	    end

		def turn(player, position, count)
			if player.index == 0
				print "I chose: ".colorize(:yellow)
				val = bestmove(position,player,2)
				#puts "I have chosen...".colorize(:yellow)

				print_move(val[0])

				return val[0]
			elsif player.index == 1
				@@count = @@count+1
				
				puts "Your options ...".colorize(:yellow)
				options_prompt = get_options(position, player)
				
				if options_prompt != nil
					move_choice = @ui.get_input(options_prompt.print_options, count)
					if move_choice =~ /[q]$|(quit)/i
						puts "Quitting..."
						abort("Goodbye.")
					end
				else
					return nil
				end
				while !(1..3).include?(move_choice.to_i)
					puts "Please Choose a valid option.".colorize(:red)
					move_choice = @ui.get_input(options_prompt.print_options,count) 
				end
				final_choice = options_prompt.choose_key(move_choice.to_i, @ui, count) #if "back"
				
				while final_choice == 0
					puts "Your options ...".colorize(:yellow)
					options_prompt = get_options(position, player)

					if options_prompt != nil
						move_choice = @ui.get_input(options_prompt.print_options, count)
						if move_choice =~ /[q]$|(quit)/i
						puts "Quitting..."
						abort("Goodbye.")
					end
					else
						return nil
					end
					while !(1..3).include?(move_choice.to_i)
						puts "Please Choose a valid option.".colorize(:red)
						move_choice = @ui.get_input(options_prompt.print_options,count) 
					end
					final_choice = options_prompt.choose_key(move_choice.to_i, @ui, count)
				end



				print "You chose: ".colorize(:yellow)
				#puts "#{final_choice.origin.x}, #{final_choice.origin.y} |"+ (final_choice.class == Insert ? "Direction: #{final_choice.x},#{final_choice.y}" : "")
				print_move(final_choice)
				return final_choice
			end
		end
		def loc_include?(arr, l)
			for loc in arr
				if loc.x == l.x && loc.y == l.y
					return true
				end
			end
			return false 
		end
		def print_move(move)
			if move.class == Insert
				puts "#{move.origin.pretty_string} + #{move.direction[move.x][move.y]}...#{move.new_prong_reserve}"
			elsif move.class == Hop
				puts "#{move.origin.pretty_string} - #{move.destination.pretty_string}" 
			elsif move.class == Jump
				print "#{move.origin.pretty_string} - " 
				
				j=0
				while j < move.steps.length || j < move.jumped_pods.length
					if j < move.steps.length
						if loc_include?(move.jumped_pods, move.steps[j]) 
							print "#{move.steps[j].pretty_string}x - "
						else
							print "#{move.steps[j].pretty_string} - "
						end
					end 
					j = j + 1
				end
				puts "#{move.destination.pretty_string}" 
			else
				puts "ERROR: Move is nil: #{move}".colorize(:red)
			end
		end

		def all_moves(index)
			for move in @moves_made[index]
				print_move(move)
			end
		end

		def get_options(position, player)
			all = position.legal_moves(player)
			if all.flatten != nil
				oh = OptionHash.new(all, player)
				return oh
			end 
			return nil
		end

		def winner(value, player, position)

			if value == 500000
				if player.index == 0
					abort( "GAME OVER. You lose.")
				elsif player.index == 1
					abort( "GAME OVER. You win!")
				end
			end

		end
	end
end