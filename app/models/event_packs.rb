class EventPacks

  EventPack = Struct.new(:name, :events) do
    def bg_image
      self.events.first.get_file
    end
    def love_scene
      self.events.first.is_a?(LovePoseEvent)
    end
  end

  def self.locations project
    out = []
    out << EventPack.new("School Roof",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg")])
    out << EventPack.new("School Hallway",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_hallway.jpg")])
    out << EventPack.new("Classroom",[BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_classroom.jpg")])
    if ami = Character.by_name_and_project(Ami, project).first
      out << EventPack.new("Suspense (love scene)",[
        LovePoseEvent.new(:filename => "/LovePose/Base/her_room_front.jpg"),
        CharacterPoseEvent.new(:filename=>"/Character/Ami/LovePose/Base/undies_front.png", :character_id=>ami.id)
      ])
    end
    out
  end










end