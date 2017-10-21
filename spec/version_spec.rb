require "swiftproj"

RSpec.describe Swiftproj::VERSION do
  it "has three version components" do
    components = Swiftproj::VERSION.split(".")
    expect(components.length).to eq 3
  end
end
