require "swiftproj"

RSpec.describe Swiftproj::Command do
  before(:each) do
    @command = get_command()
  end

  it "displays an error message" do
    # when
    @command.run("WRONG_COMMAND")

    # assert
    expect(@ui).to have_received(:puts)
  end

  describe "#command_class" do
    it "returns a proper command class" do
      expect(@command.get_command("generate-xcodeproj")).to \
        be_a Swiftproj::GenerateXcodeprojCommand
      expect(@command.get_command("help")).to be_a Swiftproj::HelpCommand
    end

    it "raises an exception when command class not found" do
      expect { @command.command_class("unknown-command") }.to \
        raise_exception(Swiftproj::UnknownCommandError)
    end
  end

  describe "#parse_options" do
    it "returns an empty hash when there is no argv" do
      options = @command.parse_options([])
      expect(options).to eq Hash.new
    end

    it "returns a single option with no value" do
      options = @command.parse_options(["--foo"])
      expect(options).to eq({ "--foo" => nil })
    end

    it "returns a single option with a key and a value" do
      options = @command.parse_options(["--foo", "bar"])
      expect(options).to eq({ "--foo" => "bar" })
    end

    it "returns multiple options" do
      argv = ["--foo", "--bar", "--hello", "world", "-a", "b"]
      options = @command.parse_options(argv)
      expect(options).to eq({
        "--foo" => nil,
        "--bar" => nil,
        "--hello" => "world",
        "-a" => "b",
      })
    end
  end
end
