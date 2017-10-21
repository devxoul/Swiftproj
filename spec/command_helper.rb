require "swiftproj"
require "xcodeproj"

module CommandHelper
  def get_command(command_name=nil)
    @core = instance_spy(Swiftproj::Core)
    @ui = spy("IO")
    @file = spy("File")
    @project = instance_spy(Xcodeproj::Project)
    @project_class = spy("Project Class").tap { |cls|
      allow(cls).to receive(:open).and_return(@project)
    }
    @scheme = instance_spy(Xcodeproj::XCScheme)
    @scheme_class = spy("Scheme Class").tap { |cls| 
      allow(cls).to receive(:new).and_return(@scheme)
    }

    command = Swiftproj::Command.new(
      :core => @core,
      :ui => @ui,
      :file => @file,
      :project_class => @project_class,
      :scheme_class => @scheme_class,
    )
    if command_name.nil?
      return command
    else
      return command.get_command(command_name)
    end
  end
end
