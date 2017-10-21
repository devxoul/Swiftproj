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
    podspec_file = instance_double(File, :read => "Hello, world!")
    allow(@file).to receive(:open).and_return(podspec_file)

    # when
    @command.run(["URLNavigator.podspec"])

    # assert
    expect(@core).to have_received(:generate_xcconfig).with("Hello, world!")
  end
end
