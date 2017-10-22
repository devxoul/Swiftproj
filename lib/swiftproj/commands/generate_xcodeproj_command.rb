module Swiftproj
  class GenerateXcodeprojCommand < Command
    def self.description()
      return "Generates a xcconfig file from podspec file"
    end

    def run(options)
      argv = []
      for key, value in options
        argv.push(key)
        argv.push(value) unless value.nil?
      end
      @core.generate_xcodeproj(argv)
    end
  end
end
