require "swiftproj"

module Swiftproj
  class AddSystemFrameworkCommand < Command
    def run(options)
      case options.count
      when 0
        raise Swiftproj::MissingArgumentError.new("project_path")
      when 1
        raise Swiftproj::MissingArgumentError.new("target_name")
      when 2
        raise Swiftproj::MissingArgumentError.new("framework_path")
      end

      (project_path, target_name, framework_path) = options
      begin
        project = @project_class.open(project_path)
      rescue
        raise Swiftproj::NoSuchFileError.new(project_path)
      end

      @core.add_system_framework(project, target_name, framework_path)
    end
  end
end
