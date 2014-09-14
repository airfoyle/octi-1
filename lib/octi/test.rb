require_relative "location"

while true
  puts "Type two numerical digits: "
  line = gets
  md = line.match(/[1-9][1-9]/)
  if md
    cl = md.begin(0)
    l1 = Octi::Location.from_string(line[cl..(cl+1)]);
    puts "Location: " + l1.to_s;
    pretty = l1.pretty_string;
    puts "Pretty: " + pretty;
  end
end  


