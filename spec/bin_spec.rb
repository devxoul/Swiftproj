RSpec.describe "swiftproj" do
  it "can be evaluated" do
    path = "#{File.dirname(__FILE__)}/../bin/swiftproj"
    content = File.open(path).read
    allow($stdout).to receive(:puts)  # mute stdout
    eval(content)
  end
end
