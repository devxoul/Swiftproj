require "swiftproj"

module Swiftproj
  class ConfigureSchemeCommand < Command
    def run(options)
      case options.count
      when 0
        raise Swiftproj::MissingArgumentError.new("project_path")
      when 1
        raise Swiftproj::MissingArgumentError.new("scheme_name")
      when 2
        raise Swiftproj::MissingArgumentError.new("buildable_target_names")
      end

      (project_path, scheme_name, buildable_target_names) = options
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
