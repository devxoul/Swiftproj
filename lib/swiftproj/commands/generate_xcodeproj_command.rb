module Swiftproj
  class GenerateXcodeprojCommand < Command
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
