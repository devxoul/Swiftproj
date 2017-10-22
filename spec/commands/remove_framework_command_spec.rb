require "swiftproj"

describe Swiftproj::RemoveFrameworkCommand do
  before(:each) do
    @command = get_command("remove-framework")
  end

  it "raises an error when the required arguments are missing" do
    error_class = Swiftproj::MissingArgumentError
    expect { @command.run({}) }.to raise_error(error_class)
    expect { @command.run({ "--project" => nil }) }.to raise_error(error_class)
    expect {
      @command.run({
        "--project" => "foo",
        "--target" => nil,
      })
    }.to raise_error(error_class)
    expect {
      @command.run({
        "--project" => "foo",
        "--target" => "bar",
        "--framework" => nil,
      })
    }.to raise_error(error_class)
  end

  it "raises an error when there's no Xcode project" do
    # given
    allow(@project_class).to receive(:open).and_raise(RuntimeError.new)

    # when
    options = {
      "--project" => "foo",
      "--target" => "ReactorKit",
      "--framework" => "Stubber.framework",
    }

    # assert
    expect { @command.run(options) }.to \
      raise_error(Swiftproj::NoSuchFileError)
  end

  it "executes Core#remove_framework" do
    # when
    options = {
      "--project" => "ReactorKit.xcodeproj",
      "--target" => "ReactorKit",
      "--framework" => "Stubber.framework",
    }
    @command.run(options)

    # assert
    expect(@core).to have_received(:remove_framework) \
      .with(@project, "ReactorKit", "Stubber.framework")
  end
end
