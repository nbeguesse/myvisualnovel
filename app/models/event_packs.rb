class EventPacks

  EventPack = Struct.new(:name, :events) do
    def bg_image
      self.events.first.get_file
    end
  end

  def self.locations
    out = []
    out << EventPack.new("School Roof",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg")])
    out << EventPack.new("School Hallway",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_hallway.jpg")])
    out << EventPack.new("Classroom",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_classroom.jpg")])
    out << EventPack.new("Her Bedroom",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/her_bedroom.jpg")])
    out
  end

  def self.default_scene
    scene = Scene.new
    scene.events << BackgroundImageEvent.new(:order_index=>1, :filename=> "#{BackgroundImageEvent.folder}/school_roof.jpg")
    scene
  end








end