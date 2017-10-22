module Swiftproj
  class VersionCommand < Command
    def self.description()
      return "Displays the current version of swiftproj"
    end

    def run(options)
      @ui.puts Swiftproj::VERSION
    end
  end
end
