require "swiftproj"

describe Swiftproj::ConfigureSchemeCommand do
  before(:each) do
    @command = get_command("configure-scheme")
  end

  it "raises an error when the required arguments are missing" do
    error_class = Swiftproj::MissingArgumentError
    expect { @command.run([]) }.to raise_error(error_class)
    expect { @command.run(["a"]) }.to raise_error(error_class)
    expect { @command.run(["a", "b"]) }.to raise_error(error_class)
  end

  it "raises an error when there's no scheme" do
    allow(@scheme_class).to receive(:new).and_raise(RuntimeError.new)
    expect { @command.run(["a", "b", "c"]) }.to \
      raise_error(Swiftproj::NoSuchFileError)
  end

  it "executes Core#configure_scheme_with_buildable_targets" do
    # when
    names = "URLNavigator,URLMatcher"
    @command.run(["URLNavigator.xcodeproj", "URLNavigator-Package", names])

    # assert
    expect(@core).to have_received(:configure_scheme_with_buildable_targets) \
      .with(@scheme, names.split(","))
  end
end
