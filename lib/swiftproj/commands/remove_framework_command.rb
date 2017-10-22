require "swiftproj"

module Swiftproj
  class RemoveFrameworkCommand < Command
    def self.description()
      return "Removes a framework from a target"
    end

    def self.options()
      return {
        "--project" => "A xcodeproj path (e.g. ReactorKit.xcodeproj)",
        "--target" => "A target name",
        "--framework" => "A framework name to be removed (e.g. XCTest.framework)",
      }
    end

    def run(options)
      project_path = options["--project"]
      target_name = options["--target"]
      framework_name = options["--framework"]

      if project_path.nil?
        raise Swiftproj::MissingArgumentError.new("--project")
      end
      if target_name.nil?
        raise Swiftproj::MissingArgumentError.new("--target")
      end
      if framework_name.nil?
        raise Swiftproj::MissingArgumentError.new("--framework")
      end

      begin
        project = @project_class.open(project_path)
      rescue
        raise Swiftproj::NoSuchFileError.new(project_path)
      end

      @core.remove_framework(project, target_name, framework_name)
    end
  end
end
