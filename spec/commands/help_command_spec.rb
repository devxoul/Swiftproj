require "swiftproj"

RSpec.describe Swiftproj::VersionCommand do
  before(:each) do
    @command = get_command("help")
  end

  it "displays help message" do
    # when
    @command.run({})

    # assert
    expect(@ui).to have_received(:puts).with(
      /generate-xcodeproj
      |generate-xcconfig
      |add-system-framework
      |remove-framework
      |configure-scheme
      |help
      |version/,
    )
  end
end
