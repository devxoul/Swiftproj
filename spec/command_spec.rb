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
end
