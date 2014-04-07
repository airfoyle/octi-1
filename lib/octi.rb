require_relative "octi/version"

module Octi
end

require_relative "./octi/core_extensions.rb"
lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/octi/**/*.rb"].each { |file| require file }



