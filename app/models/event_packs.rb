class EventPacks

  EventPack = Struct.new(:name, :events) do
    def bg_image
      self.events.first.get_file
    end
    def love_scene
      self.events.first.is_a?(LovePoseEvent)
    end
    def get_love_scene_pose
      self.events.first.filename
    end
  end

  def self.locations
    out = []
    out << EventPack.new("School Roof",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg")])
    out << EventPack.new("School Hallway",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_hallway.jpg")])
    out << EventPack.new("Classroom",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_classroom.jpg")])
    out << EventPack.new("The Next Morning (love scene)",[LovePoseEvent.new(:filename=>"/Character/Female/F/Intimate/y-mia-zoom(a).gif", :subfilename => "#{BackgroundImageEvent.folder}/her_bedroom.jpg")])
    out
  end










end