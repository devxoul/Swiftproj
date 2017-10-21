module Swiftproj
  class Error < RuntimeError
  end

  class MissingPodspecVersionError < Error
  end

  class NoSuchTargetError < Error
  end

  class NoFrameworksBuildPhaseError < Error
  end

  class NoFrameworkError < Error
  end

  class MissingArgumentError < Error
    def initialize(argument_name)
      @argument_name = argument_name
    end

    def message()
      return "Required argument is missing: #{@argument_name}"
    end
  end

  class UnknownCommandError < Error
  end

  class NoSuchFileError < Error
    def initialize(path)
      @path = path
    end

    def message()
      return "No such file: #{@path}"
    end
  end
end
