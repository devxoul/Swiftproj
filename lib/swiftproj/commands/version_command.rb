module Swiftproj
  class VersionCommand < Command
    def run(options)
      @ui.puts Swiftproj::VERSION
    end
  end
end
