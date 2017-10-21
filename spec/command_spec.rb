require "swiftproj"

RSpec.describe Swiftproj::Command do
  before(:each) do
    @core = spy("Core")
    @ui = spy("$stdout")
    @command = Swiftproj::Command.new(:core => @core,
                                      :ui => @ui)
  end

  describe "#version" do
    it "displays current version" do
      # when
      @command.run(%w(version))

      # assert
      expect(@ui).to have_received(:puts).with(Swiftproj::VERSION)
    end
  end
end
