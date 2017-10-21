require "swiftproj"
require "xcodeproj"
require "rexml/document"

RSpec.describe Swiftproj::Core do
  before(:each) do
    @ui = spy("$stdout")
    @shell = spy("Shell")
    @file = spy("File")
    @core = Swiftproj::Core.new(
      :ui => @ui,
      :shell => @shell,
      :file => @file
    )
  end

  describe "#generate_xcodeproj" do
    it "runs a shell command" do
      # when
      @core.generate_xcodeproj()

      # assert
      command = "swift package generate-xcodeproj"
      expect(@shell).to have_received(:run).with(command)
    end

    it "runs a shell command with given arguments" do
      # when
      @core.generate_xcodeproj(%w(--enable-code-coverage foo))

      # assert
      command = "swift package generate-xcodeproj --enable-code-coverage foo"
      expect(@shell).to have_received(:run).with(command)
    end
  end

  describe "#generate_xcconfig" do
    it "generates a xcconfig file from a podspec" do
      # given
      podspec = Pod::Spec.new
      podspec.version = "1.2.3"
      podspec.ios.deployment_target = "8.0"
      podspec.osx.deployment_target = "10.11"
      podspec.tvos.deployment_target = "9.0"
      podspec.watchos.deployment_target = "2.0"

      # when
      @core.generate_xcconfig(podspec)

      # assert
      config = "CURRENT_PROJECT_VERSION = 1.2.3\n"
      config += "IPHONEOS_DEPLOYMENT_TARGET = 8.0\n"
      config += "MACOSX_DEPLOYMENT_TARGET = 10.11\n"
      config += "TVOS_DEPLOYMENT_TARGET = 9.0\n"
      config += "WATCHOS_DEPLOYMENT_TARGET = 2.0\n"
      expect(@file).to have_received(:write).with("Config.xcconfig", config)
    end

    it "generates a xcconfig file from a podspec without unspecified os" do
      # given
      podspec = Pod::Spec.new
      podspec.version = "0.2"
      podspec.osx.deployment_target = "10.11"
      podspec.tvos.deployment_target = "9.0"

      # when
      @core.generate_xcconfig(podspec)

      # assert
      config = "CURRENT_PROJECT_VERSION = 0.2\n"
      config += "MACOSX_DEPLOYMENT_TARGET = 10.11\n"
      config += "TVOS_DEPLOYMENT_TARGET = 9.0\n"
      expect(@file).to have_received(:write).with("Config.xcconfig", config)
    end
  end

  describe "#add_system_framework" do
    before(:each) do
      @target_urlnavigator = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "URLNavigator",
        :frameworks_build_phase => instance_spy(
          Xcodeproj::Project::Object::PBXFrameworksBuildPhase
        )
      )
      @target_quick = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "Quick",
        :frameworks_build_phase => nil
      )
      @target_quickspecbase = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "QuickSpecBase",
        :frameworks_build_phase => instance_spy(
          Xcodeproj::Project::Object::PBXFrameworksBuildPhase
        )
      )
      targets = [@target_urlnavigator, @target_quick, @target_quickspecbase]

      @file = instance_double(Xcodeproj::Project::Object::PBXFileReference)
      @project = instance_spy(
        Xcodeproj::Project,
        :targets => targets,
        :new_file => @file
      )
    end

    it "raises an error when there's no such a target" do
      expect {
        path = "/path/to/XCTest.framework"
        @core.add_system_framework(@project, "HelloWorld", path)
      }.to raise_error(Swiftproj::NoSuchTargetError)
    end

    it "raises an error when a target doesn't have a frameworks build phase" do
      expect {
        path = "/path/to/XCTest.framework"
        @core.add_system_framework(@project, "Quick", path)
      }.to raise_error(Swiftproj::NoFrameworksBuildPhaseError)
    end

    it "adds a system framework to a target" do
      # when
      path = "/path/to/XCTest.framework"
      @core.add_system_framework(@project, "QuickSpecBase", path)

      # assert
      phase = @target_quickspecbase.frameworks_build_phase
      expect(phase).to have_received(:add_file_reference).with(@file)
      expect(@project).to have_received(:save)
    end
  end

  describe "#remove_framework" do
    before(:each) do
      @rx_blocking = instance_double(
        Xcodeproj::Project::Object::PBXFileReference,
        :path => "RxBlocking.framework"
      )
      @rx_cocoa = instance_double(
        Xcodeproj::Project::Object::PBXFileReference,
        :path => "RxCocoa.framework"
      )
      @rx_cocoaruntime = instance_double(
        Xcodeproj::Project::Object::PBXFileReference,
        :path => "RxCocoaRuntime.framework"
      )
      @rx_swift = instance_double(
        Xcodeproj::Project::Object::PBXFileReference,
        :path => "RxBlocking.framework"
      )
      files = [@rx_blocking, @rx_cocoa, @rx_cocoaruntime, @rx_swift]

      @target_reactorkit = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "ReactorKit",
        :frameworks_build_phase => instance_spy(
          Xcodeproj::Project::Object::PBXFrameworksBuildPhase,
          :files_references => files
        )
      )
      @target_reactorkitruntime = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "ReactorKitRuntime",
        :frameworks_build_phase => nil
      )
      @target_stubber = instance_spy(
        Xcodeproj::Project::Object::PBXNativeTarget,
        :name => "Stubber",
        :frameworks_build_phase => instance_spy(
          Xcodeproj::Project::Object::PBXFrameworksBuildPhase,
          :files_references => files
        )
      )
      @targets = [
        @target_reactorkit, @target_reactorkitruntime, @target_stubber
      ]

      @project = instance_spy(Xcodeproj::Project, :targets => @targets)
    end

    it "raises an error when there's no such a target" do
      expect {
        path = "/path/to/XCTest.framework"
        @core.remove_framework(@project, "HelloWorld", path)
      }.to raise_error(Swiftproj::NoSuchTargetError)
    end

    it "raises an error when a target doesn't have a frameworks build phase" do
      expect {
        @core.remove_framework(@project, "ReactorKitRuntime", "Foo.framework")
      }.to raise_error(Swiftproj::NoFrameworksBuildPhaseError)
    end

    it "raises an error when there's no such a framework in a phase" do
      expect {
        path = "/path/to/XCTest.framework"
        @core.remove_framework(@project, "ReactorKit", "HelloWorld.framework")
      }.to raise_error(Swiftproj::NoFrameworkError)
    end

    it "removes a framework from a target" do
      # when
      @core.remove_framework(@project, "ReactorKit", "RxBlocking.framework")

      # assert
      phase = @target_reactorkit.frameworks_build_phase
      expect(phase).to have_received(:remove_file_reference).with(@rx_blocking)
      expect(@project).to have_received(:save)
    end
  end

  describe "#configure_scheme_with_buildable_targets" do
    before(:each) do
      def new_entry(blueprint_name)
        xml_element = REXML::Element.new("BuildableReference")
        xml_element.attributes["BlueprintName"] = blueprint_name
        reference = Xcodeproj::XCScheme::BuildableReference.new(xml_element)
        entry = Xcodeproj::XCScheme::BuildAction::Entry.new
        entry.add_buildable_reference(reference)
        return entry
      end

      build_action = Xcodeproj::XCScheme::BuildAction.new
      build_action.add_entry(new_entry("URLNavigator"))
      build_action.add_entry(new_entry("URLMatcher"))
      build_action.add_entry(new_entry("Quick"))
      build_action.add_entry(new_entry("QuickSpecBase"))
      build_action.add_entry(new_entry("Nimble"))
      build_action.add_entry(new_entry("Stubber"))

      class Scheme
        attr_accessor :build_action

        def save!
        end
      end

      @scheme = Scheme.new
      @scheme.build_action = build_action
      allow(@scheme).to receive(:save!)
    end

    it "configures a scheme to have only buildable targets" do
      # when
      target_names = ["URLNavigator", "URLMatcher"]
      @core.configure_scheme_with_buildable_targets(@scheme, target_names)

      # assert
      names = @scheme.build_action.entries.map { |e|
        e.buildable_references[0].blueprint_name
      }
      expect(names).to eq target_names
      expect(@scheme).to have_received(:save!)
    end
  end
end
