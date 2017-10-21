require "swiftproj"

RSpec.describe Swiftproj::GenerateXcodeprojCommand do
  before(:each) do
    @command = get_command("generate-xcodeproj")
  end

  it "executes Core#generate_xcodeproj" do
    # when
    @command.run([])

    # assert
    expect(@core).to have_received(:generate_xcodeproj).with([])
  end

  it "forwards arguments to Core#generate_xcodeproj" do
    # when
    @command.run(["foo", "bar"])

    # assert
    expect(@core).to have_received(:generate_xcodeproj).with(["foo", "bar"])
  end
end
