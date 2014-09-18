require_relative "location"
require_relative "move"

while true
  puts "Type a location: "
  line = gets.chomp!
  md = line.match(/[1-9][1-9]/)
  if md
    cl = md.begin(0)
    l1 = Octi::Location.from_string(line[cl..(cl+1)]);
    puts "Location: " + l1.to_s;
    pretty = l1.pretty_string;
    puts "Pretty: " + pretty;
  end
end  


