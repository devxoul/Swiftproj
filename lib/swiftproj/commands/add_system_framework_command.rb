require "swiftproj"

module Swiftproj
  class AddSystemFrameworkCommand < Command
    def self.description()
      return "Adds a system framework to an existing target"
    end

    def self.options()
      return {
        "--project" => "A xcodeproj path (e.g. ReactorKit.xcodeproj)",
        "--target" => "A target name",
        "--framework" => "A framework path to be added (e.g. Platforms/iPhoneOS.platform/Developer/Library/Frameworks/XCTest.framework)",
      }
    end

    def run(options)
      project_path = options["--project"]
      target_name = options["--target"]
      framework_path = options["--framework"]

      if project_path.nil?
        raise Swiftproj::MissingArgumentError.new("--project")
      end
      if target_name.nil?
        raise Swiftproj::MissingArgumentError.new("--target")
      end
      if framework_path.nil?
        raise Swiftproj::MissingArgumentError.new("--framework")
      end

      begin
        project = @project_class.open(project_path)
      rescue
        raise Swiftproj::NoSuchFileError.new(project_path)
      end

      @core.add_system_framework(project, target_name, framework_path)
    end
  end
end
