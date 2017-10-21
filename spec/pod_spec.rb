require "Swiftproj"

RSpec.describe Pod::Spec do
  describe "#initialize" do
    it "has empty deployment_targets" do
      # given
      spec = Pod::Spec.new

      # assert
      expect(spec.ios.deployment_target).to be_nil
      expect(spec.osx.deployment_target).to be_nil
      expect(spec.tvos.deployment_target).to be_nil
      expect(spec.watchos.deployment_target).to be_nil
    end
  end

  describe "#from_podspec" do
    it "parses all properties" do
      # given
      spec = Pod::Spec.from_podspec %{
        Pod::Spec.new do |s|
          s.version = "1.0.0"
          s.ios.deployment_target = "8.0"
          s.osx.deployment_target = "10.11"
          s.tvos.deployment_target = "9.0"
          s.watchos.deployment_target = "2.0"
        end
      }

      # assert
      expect(spec.version).to eq "1.0.0"
      expect(spec.ios.deployment_target).to eq "8.0"
      expect(spec.osx.deployment_target).to eq "10.11"
      expect(spec.tvos.deployment_target).to eq "9.0"
      expect(spec.watchos.deployment_target).to eq "2.0"
    end

    it "parses only given deployment targets" do
      # given
      spec = Pod::Spec.from_podspec %{
        Pod::Spec.new do |s|
          s.version = "1.0.0"
          s.ios.deployment_target = "9.0"
          s.tvos.deployment_target = "10.0"
        end
      }

      # assert
      expect(spec.version).to eq "1.0.0"
      expect(spec.ios.deployment_target).to eq "9.0"
      expect(spec.osx.deployment_target).to be_nil
      expect(spec.tvos.deployment_target).to eq "10.0"
      expect(spec.watchos.deployment_target).to be_nil
    end

    it "throws an error when the podspec doesn't have a version info" do
      expect {
        spec = Pod::Spec.from_podspec %{
          Pod::Spec.new do |s|
            s.ios.deployment_target = "9.0"
          end
        }
      }.to raise_error(Swiftproj::MissingPodspecVersionError)
    end
  end
end
