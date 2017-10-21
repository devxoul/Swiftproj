require "swiftproj"

RSpec.describe Swiftproj::GenerateXcconfigCommand do
  before(:each) do
    @command = get_command("generate-xcconfig")
  end

  it "raises an error when the required argument is missing" do
    expect { @command.run([]) }.to raise_error(Swiftproj::MissingArgumentError)
  end

  it "raises an error when there's no podspec" do
    allow(@file).to receive(:open).and_raise(Errno::ENOENT.new)
    expect { @command.run(["foo"]) }.to raise_error(Swiftproj::NoSuchFileError)
  end

  it "executes Core#generate_xcconfig" do
    # given
    podspec_content = %(
      Pod::Spec.new do |s|
        s.version = "1.0.0"
        s.ios.deployment_target = "8.0"
        s.osx.deployment_target = "10.11"
        s.tvos.deployment_target = "9.0"
        s.watchos.deployment_target = "2.0"
      end
    )
    podspec_file = instance_double(File, :read => podspec_content)
    allow(@file).to receive(:open).and_return(podspec_file)

    # when
    @command.run(["URLNavigator.podspec"])

    # assert
    podspec = Pod::Spec.from_podspec(podspec_content)
    expect(@core).to have_received(:generate_xcconfig).with(podspec)
  end
end
