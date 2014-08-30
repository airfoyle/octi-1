module Octi
	class UserInterface
		
	  def print_message(message)
	    puts message
	  end


	  def get_input(prompt,count)
	    print "[Turn #{count}]>>"
	    STDIN.gets.chomp
	  end

	end
end