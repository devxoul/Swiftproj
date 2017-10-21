module Swiftproj
  require "swiftproj/error"
  require "swiftproj/pod"
  require "swiftproj/version"
  require "swiftproj/xcodehelper"

  autoload :Command,   "swiftproj/command"
  autoload :Core,      "swiftproj/core"
  autoload :Shell,     "swiftproj/shell"
end
