require_relative "octi/version"
require "awesome_print"
require 'debugger'
require 'colorize'
require "deep_clone"

module Octi
end

require_relative "./octi/core_extensions.rb"
lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/octi/**/*.rb"].each { |file| require file }

game = Octi::Game.new
# class Obj
# 	def initialize(num)
# 		@num = num
# 	end
# 	def num
# 		return @num
# 	end

# 	def c(num)
# 		@num = num
# 		return @num
# 	end
# end

# a = Obj.new(0)

# b = a.clone

# puts "a: #{a.num} | b: #{b.num}".green
# puts "a: #{a.num} | b: #{b.c(3)}".red
# puts "a: #{a.clear} | b: #{b.num}".green
