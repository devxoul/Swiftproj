require "swiftproj"

RSpec.describe Swiftproj::MissingArgumentError do
  it "#message" do
    error = Swiftproj::MissingArgumentError.new("helloworld")
    expect(error.message).to include("helloworld")
  end
end

RSpec.describe Swiftproj::NoSuchFileError do
  it "#message" do
    error = Swiftproj::NoSuchFileError.new("foo.txt")
    expect(error.message).to include("foo.txt")
  end
end
