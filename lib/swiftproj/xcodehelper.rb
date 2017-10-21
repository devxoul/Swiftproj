require "xcodeproj"

module Xcodeproj
  class XCScheme
    class BuildableReference
      def blueprint_name()
        return @xml_element.attributes["BlueprintName"]
      end
    end
  end
end
