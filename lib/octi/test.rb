["location", "move", "pod"].each { |f|
   require_relative f
   }

module Octi
  while true
    puts "Type a move: "
    line = gets.chomp!
    break if line.length == 0
    begin
      mr = Move.parse_move(line)
      puts "Move: #{mr}"
    rescue => e
      puts "*** Unexpected #{e}"
    end
  end
  puts "Bye!"
end

