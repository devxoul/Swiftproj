require "swiftproj"

describe Swiftproj::ConfigureSchemeCommand do
  before(:each) do
    @command = get_command("configure-scheme")
  end

  it "raises an error when the required arguments are missing" do
    error_class = Swiftproj::MissingArgumentError
    expect { @command.run({}) }.to raise_error(error_class)
    expect { @command.run({ "--project" => nil }) }.to raise_error(error_class)
    expect {
      @command.run({
        "--project" => "foo",
        "--scheme" => nil,
      })
    }.to raise_error(error_class)
    expect {
      @command.run({
        "--project" => "foo",
        "--scheme" => "bar",
        "--buildable-targets" => nil,
      })
    }.to raise_error(error_class)
  end

  it "raises an error when there's no scheme" do
    # given
    allow(@scheme_class).to receive(:new).and_raise(RuntimeError.new)

    # when
    options = {
      "--project" => "foo",
      "--scheme" => "bar",
      "--buildable-targets" => "baz",
    }

    # assert
    expect { @command.run(options) }.to raise_error(Swiftproj::NoSuchFileError)
  end

  it "executes Core#configure_scheme_with_buildable_targets" do
    # when
    options = {
      "--project" => "URLNavigator.xcodeproj",
      "--scheme" => "URLNavigator-Package",
      "--buildable-targets" => "URLNavigator,URLMatcher",
    }
    @command.run(options)

    # assert
    expect(@core).to have_received(:configure_scheme_with_buildable_targets) \
      .with(@scheme, ["URLNavigator", "URLMatcher"])
  end
end
