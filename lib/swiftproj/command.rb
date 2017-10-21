module Swiftproj
  class Command
    def initialize(core:, ui:)
      @core = core
      @ui = ui
    end

    def run(argv)
      case argv[0]
      when "version"
        @ui.puts Swiftproj::VERSION
      end
    end
  end
end
