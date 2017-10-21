module Swiftproj
  class Shell
    def run(command)
      return `#{command}`
    end
  end
end
