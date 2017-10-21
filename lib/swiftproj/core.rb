module Swiftproj
  class Core
    def initialize(ui:, shell:, file:)
      @ui = ui
      @shell = shell
      @file = file
    end

    def generate_xcodeproj(argv=nil)
      command = "swift package generate-xcodeproj"
      if argv
        command += " " + argv.join(" ")
      end
      @shell.run(command)
    end

    def generate_xcconfig(podspec)
      config = "CURRENT_PROJECT_VERSION = #{podspec.version}\n"
      if target = podspec.ios.deployment_target
        config += "IPHONEOS_DEPLOYMENT_TARGET = #{target}\n"
      end
      if target = podspec.osx.deployment_target
        config += "MACOSX_DEPLOYMENT_TARGET = #{target}\n"
      end
      if target = podspec.tvos.deployment_target
        config += "TVOS_DEPLOYMENT_TARGET = #{target}\n"
      end
      if target = podspec.watchos.deployment_target
        config += "WATCHOS_DEPLOYMENT_TARGET = #{target}\n"
      end
      @file.write("Config.xcconfig", config)
    end

    def add_system_framework(project, target_name, framework_path)
      target = project.targets.find { |t| t.name == target_name }
      if target.nil?
        raise Swiftproj::NoSuchTargetError.new
      end

      build_phase = target.frameworks_build_phase
      if build_phase.nil?
        raise Swiftproj::NoFrameworksBuildPhaseError.new
      end

      file = project.new_file(framework_path)
      build_phase.add_file_reference(file)
      project.save
    end

    def remove_framework(project, target_name, framework_name)
      target = project.targets.find { |t| t.name == target_name }
      if target.nil?
        raise Swiftproj::NoSuchTargetError.new
      end

      build_phase = target.frameworks_build_phase
      if build_phase.nil?
        raise Swiftproj::NoFrameworksBuildPhaseError.new
      end

      file = build_phase.files_references.find { |f| f.path == framework_name }
      if file.nil?
        raise Swiftproj::NoFrameworkError.new
      end

      build_phase.remove_file_reference(file)
      project.save
    end

    def configure_scheme_with_buildable_targets(scheme, buildable_target_names)
      action = Xcodeproj::XCScheme::BuildAction.new
      for entry in scheme.build_action.entries
        blueprint_name = entry.buildable_references[0].blueprint_name
        if not buildable_target_names.include? blueprint_name
          action.add_entry(entry)
        end
      end
      scheme.build_action = action
      scheme.save!
    end
  end
end
