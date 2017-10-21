module Swiftproj
  class GenerateXcodeprojCommand < Command
    def run(options)
      @core.generate_xcodeproj(options)
    end
  end
end
