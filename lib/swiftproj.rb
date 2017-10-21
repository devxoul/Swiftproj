module Swiftproj
  require "colored2"

  require "swiftproj/error"
  require "swiftproj/pod"
  require "swiftproj/version"
  require "swiftproj/xcodehelper"

  autoload :Command,   "swiftproj/commands/command"
  autoload :Core,      "swiftproj/core"
  autoload :Shell,     "swiftproj/shell"

  commands_path = File.expand_path("../swiftproj/commands/*.rb", __FILE__)
  Dir.glob(commands_path).each do |file|
    require file
  end
end
