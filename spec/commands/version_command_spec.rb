require "swiftproj"

RSpec.describe Swiftproj::VersionCommand do
  before(:each) do
    @command = get_command("version")
  end

  it "displays current version" do
    # when
    @command.run(%w(version))

    # assert
    expect(@ui).to have_received(:puts).with(Swiftproj::VERSION)
  end
end
