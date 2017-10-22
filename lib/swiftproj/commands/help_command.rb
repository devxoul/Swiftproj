module Swiftproj
  class HelpCommand < Command
    def self.description()
      return "Displays this help message"
    end

    def run(options)
      message = Swiftproj.constants
        .map { |symbol| symbol.to_s }
        .select { |name| name != "Command" and name.end_with?("Command") }
        .map { |name| Swiftproj.const_get(name) }
        .map { |cls|
          "    " + cls.command_name.ljust(22).green + cls.description
        }
        .join("\n")
      @ui.puts(message)
    end
  end
end
