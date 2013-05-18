class EventPacks

  EventPack = Struct.new(:name, :events) do
    def bg_image
      self.events.first.get_file
    end
  end

  def self.locations
    out = []
    out << EventPack.new("School Roof",[BackgroundImageEvent.new(:filename => "school_roof.jpg")])
    out << EventPack.new("School Hallway",[BackgroundImageEvent.new(:filename => "school_hallway.jpg")])
    out << EventPack.new("Classroom",[BackgroundImageEvent.new(:filename => "school_classroom.jpg")])
    out << EventPack.new("Her Bedroom",[BackgroundImageEvent.new(:filename => "her_bedroom.jpg")])
    out
  end








end