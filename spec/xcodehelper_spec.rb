require "xcodeproj"
require "rexml/document"

RSpec.describe Xcodeproj::XCScheme::BuildableReference do
  describe("#blueprint_name") do
    it "returns blueprint name" do
      xml_element = REXML::Element.new("BuildableReference")
      xml_element.attributes["BlueprintName"] = "ReactorKit"
      reference = Xcodeproj::XCScheme::BuildableReference.new(xml_element)
      expect(reference.blueprint_name).to eq "ReactorKit"
    end
  end
end
