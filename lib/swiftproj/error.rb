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
end
