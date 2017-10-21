module Swiftproj
  class Command
    def initialize(core:, ui:, file:, project_class:, scheme_class:)
      @core = core
      @ui = ui
      @file = file
      @project_class = project_class
      @scheme_class = scheme_class
    end

    def run(argv)
      begin
        command_name = argv[0] || 'help'
        command = self.get_command(command_name)
        command.run(argv[1..-1])
      rescue Exception => e
        @ui.puts("[!] #{e.message}".red)
      end
    end

    def get_command(command_name)
      return self.command_class(command_name).new(
        :core => @core,
        :ui => @ui,
        :file => @file,
        :project_class => @project_class,
        :scheme_class => @scheme_class,
      )
    end

    def command_class(command_name)
      name = "#{command_name}-command".split("-").map { |s| s.capitalize }.join
      begin
        return Swiftproj.const_get(name)
      rescue
        raise Swiftproj::UnknownCommandError
      end
    end
  end
end
