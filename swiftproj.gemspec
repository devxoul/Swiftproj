require_relative "lib/swiftproj/version"
require "date"

Gem::Specification.new do |s|
  s.name        = "swiftproj"
  s.version     = Swiftproj::VERSION
  s.date        = Date.today
  s.summary     = "A command-line tool for managing Xcode project with Swift Package Manager"
  s.authors     = ["Suyeol Jeon"]
  s.email       = "devxoul@gmail.com"
  s.files       = ["lib/swiftproj.rb"]
  s.homepage    = "https://github.com/devxoul/Swiftproj"
  s.license     = "MIT"

  s.files = Dir["lib/**/*.rb"] + %w{ bin/swiftproj README.md LICENSE }

  s.executables   = %w{ swiftproj }
  s.require_paths = %w{ lib }

  s.add_runtime_dependency "xcodeproj", ">= 1.5"
  s.add_runtime_dependency "colored2", ">= 3.0"

  s.required_ruby_version = ">= 2.3.1"
end
