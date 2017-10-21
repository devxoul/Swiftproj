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

    def ==(spec)
      return false unless self.class == spec.class
      return false unless self.version == spec.version
      return false unless self.ios == spec.ios
      return false unless self.osx == spec.osx
      return false unless self.tvos == spec.tvos
      return false unless self.watchos == spec.watchos
      return true
    end
  end

  class OS
    attr_accessor :deployment_target

    def ==(os)
      return false unless self.class == os.class
      return false unless self.deployment_target == os.deployment_target
      return true
    end
  end
end
