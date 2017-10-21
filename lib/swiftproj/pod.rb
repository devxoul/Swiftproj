module Pod
  class Spec
    attr_accessor :version
    attr_accessor :ios
    attr_accessor :osx
    attr_accessor :tvos
    attr_accessor :watchos

    def self.from_podspec(content)
      pod = eval(content)
      if pod.version.nil?
        raise Swiftproj::MissingPodspecVersionError.new
      end
      return pod
    end

    def initialize()
      @ios = OS.new
      @osx = OS.new
      @tvos = OS.new
      @watchos = OS.new
      yield self if block_given?
    end

    def method_missing(*args)
      # do nothing
    end
  end

  class OS
    attr_accessor :deployment_target
  end
end
