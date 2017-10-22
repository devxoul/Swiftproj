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
        options = self.parse_options(argv[1..-1])
        command.run(options)
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

    def parse_options(argv)
      options = Hash.new
      return options if argv.nil?

      current_key = nil
      for arg in argv
        if arg.start_with? "-"
          current_key = arg
          options[current_key] = nil
        elsif not current_key.nil?
          options[current_key] = arg
          current_key = nil
        end
      end
      return options
    end

    def self.command_name()
      command_name = self.name \
        .split("::").last \
        .gsub(/Command$/, "") 
        .gsub(/([a-z]+)([A-Z])([a-z]+)/, '\1-\2\3')\
        .downcase
      if not command_name.nil? and command_name.empty?
        return nil
      end
      return command_name
    end

    def self.description()
      return ""
    end
  end
end
