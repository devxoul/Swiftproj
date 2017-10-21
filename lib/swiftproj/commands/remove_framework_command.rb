require "swiftproj"

module Swiftproj
  class RemoveFrameworkCommand < Command
    def run(options)
      case options.count
      when 0
        raise Swiftproj::MissingArgumentError.new("project_path")
      when 1
        raise Swiftproj::MissingArgumentError.new("target_name")
      when 2
        raise Swiftproj::MissingArgumentError.new("framework_name")
      end

      (project_path, target_name, framework_name) = options
      begin
        project = @project_class.open(project_path)
      rescue
        raise Swiftproj::NoSuchFileError.new(project_path)
      end

      @core.remove_framework(project, target_name, framework_name)
    end
  end
end
