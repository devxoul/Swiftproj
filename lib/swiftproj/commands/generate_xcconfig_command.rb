module Swiftproj
  class GenerateXcconfigCommand < Command
    def run(options)
      podspec_path = options["--podspec"]
      if podspec_path.nil?
        raise Swiftproj::MissingArgumentError.new("--podspec")
      end

      begin
        podspec_content = @file.open(podspec_path).read
      rescue
        raise Swiftproj::NoSuchFileError.new(podspec_path)
      end

      podspec = Pod::Spec.from_podspec(podspec_content)
      @core.generate_xcconfig(podspec)
    end
  end
end
