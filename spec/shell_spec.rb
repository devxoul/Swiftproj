require "swiftproj"

RSpec.describe Swiftproj::Shell do
  before(:each) do
    @shell = Swiftproj::Shell.new
  end

  describe "#run" do
    it "executes a shell command" do
      result = @shell.run("echo 'Hello, Swiftproj!'")
      expect(result).to eq "Hello, Swiftproj!\n"
    end
  end
end
