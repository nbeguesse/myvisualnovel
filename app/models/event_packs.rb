class EventPacks

  EventPack = Struct.new(:name, :love_scene, :events) do
    def bg_image
      self.events.first.get_file
    end
  end

  def self.locations
    out = []
    out << EventPack.new("School Roof",false,[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg")])
    out << EventPack.new("School Hallway",false,[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_hallway.jpg")])
    out << EventPack.new("Classroom",false,[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_classroom.jpg")])
    out << EventPack.new("Her Bedroom",true,[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/her_bedroom.jpg")])
    out
  end










end