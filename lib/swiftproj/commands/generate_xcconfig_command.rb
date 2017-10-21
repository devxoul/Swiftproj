module Swiftproj
  class GenerateXcconfigCommand < Command
    def run(options)
      if options.count < 1
        raise Swiftproj::MissingArgumentError.new("podspec")
      end

      podspec_path = options[0]
      begin
        podspec_content = @file.open(podspec_path).read
      rescue
        raise Swiftproj::NoSuchFileError.new(podspec_path)
      end

      @core.generate_xcconfig(podspec_content)
    end
  end
end