require "swiftproj"

module Swiftproj
  class ConfigureSchemeCommand < Command
    def self.description()
      return "Configures a scheme to have buildable targets only"
    end

    def run(options)
      project_path = options["--project"]
      scheme_name = options["--scheme"]
      buildable_target_names = options["--buildable-targets"]

      if project_path.nil?
        raise Swiftproj::MissingArgumentError.new("--project")
      end
      if scheme_name.nil?
        raise Swiftproj::MissingArgumentError.new("--scheme")
      end
      if buildable_target_names.nil?
        raise Swiftproj::MissingArgumentError.new("--buildable-targets")
      end

      path = "#{project_path}/xcshareddata/xcschemes/#{scheme_name}.xcscheme"
      begin
        scheme = @scheme_class.new(path)
      rescue
        raise Swiftproj::NoSuchFileError.new(project_path)
      end

      target_names = buildable_target_names.split(",")
      @core.configure_scheme_with_buildable_targets(scheme, target_names)
    end
  end
end
