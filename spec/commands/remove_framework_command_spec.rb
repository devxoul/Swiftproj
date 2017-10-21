require "swiftproj"

describe Swiftproj::RemoveFrameworkCommand do
  before(:each) do
    @command = get_command("remove-framework")
  end

  it "raises an error when the required arguments are missing" do
    error_class = Swiftproj::MissingArgumentError
    expect { @command.run([]) }.to raise_error(error_class)
    expect { @command.run(["a"]) }.to raise_error(error_class)
    expect { @command.run(["a", "b"]) }.to raise_error(error_class)
  end

  it "raises an error when there's no Xcode project" do
    allow(@project_class).to receive(:open).and_raise(RuntimeError.new)
    expect { @command.run(["a", "b", "c"]) }.to \
      raise_error(Swiftproj::NoSuchFileError)
  end

  it "executes Core#remove_framework" do
    # when
    @command.run(["ReactorKit.xcodeproj", "ReactorKit", "Stubber.framework"])

    # assert
    expect(@core).to have_received(:remove_framework) \
      .with(@project, "ReactorKit", "Stubber.framework")
  end
end
