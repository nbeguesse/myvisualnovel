class EventPacks

  EventPack = Struct.new(:name, :events) do
    def bg_image
      self.events.second.get_file
    end
    def love_scene
      self.events.second.is_a?(LovePoseEvent)
    end
    def music
      mu = self.events.first
      mu.humanize(mu.get_file)
    end
  end

  def self.locations project
    out = []

    out << EventPack.new("School Roof",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Out_To_Play.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg", :order_index=>2)
      ])
    out << EventPack.new("School Hallway",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Busy_Bodies.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_hallway.jpg", :order_index=>2)
        ])
    out << EventPack.new("Classroom",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Busy_Bodies.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_classroom.jpg", :order_index=>2)
      ])
    out << EventPack.new("Eating Out",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/City_Fun.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/Restaurant_Ext.jpg", :order_index=>2)
      ])
    out << EventPack.new("Infirmary",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Not_So_Simple_Life.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/School_infirmary.jpg", :order_index=>2)
      ])
    if ami = Character.by_name_and_project(Ami, project).first
      out << EventPack.new("Fun with #{ami.name}",[
        BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Romantic/Thru_The_Night.mp3", :order_index=>1),
        LovePoseEvent.new(:filename => "/LovePose/Base/her_room_front.jpg", :order_index=>2),
        CharacterPoseEvent.new(:filename=>"/Character/Ami/LovePose/Base/undies_front.png", :character_id=>ami.id, :order_index=>3)
      ])
      # out << EventPack.new("Action",[
      #   BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Romantic/Too_Much_To_Handle.mp3", :order_index=>1),
      #   LovePoseEvent.new(:filename => "/LovePose/Base/classroom_front.jpg", :order_index=>2),
      #   CharacterPoseEvent.new(:filename=>"/Character/Ami/LovePose/Base/during_front.png", :character_id=>ami.id, :order_index=>3)
      # ])
      out << EventPack.new("The One I Love",[
        BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Tender_For_A_Moment.mp3", :order_index=>1),
        LovePoseEvent.new(:filename => "/LovePose/Base/bubble_big.jpg", :order_index=>2),
        CharacterPoseEvent.new(:filename=>"/Character/Ami/LovePose/Base/closeup_big.png", :character_id=>ami.id, :order_index=>3)
      ])      
    end
    if ajax = Character.by_name_and_project(Ajax, project).first
      out << EventPack.new("Fun with #{ajax.name}",[
        BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Romantic/Too_Much_To_Handle.mp3", :order_index=>1),
        LovePoseEvent.new(:filename => "/LovePose/Base/classroom_front.jpg", :order_index=>2),
        CharacterPoseEvent.new(:filename=>"/Character/Ajax/LovePose/Base/gym_front.png", :character_id=>ajax.id, :order_index=>3)
      ])      
    end

    out
  end



  def self.starter_scene project
    out = []
    ami = Character.by_name_and_project(Ami, project).first
    out << EventPack.new("Example Scene",[
      BackgroundMusicEvent.new(:filename => "/#{BackgroundMusicEvent.folder}/Base/Out_To_Play.mp3", :order_index=>1),
      BackgroundImageEvent.new(:filename => "#{BackgroundImageEvent.folder}/school_roof.jpg", :order_index=>2),
      CharacterPoseEvent.new(:filename=>"/Character/Ami/Pose/Base/uniform.png", :character_id=>ami.id, :subfilename=>"/Character/Ami/Face/Base/happy.png", :order_index=>3),
      CharacterSpeaksEvent.new(:character_id=>ami.id, :text=>'Welcome! To start adding to the script, just edit this scene and click where it says "Add to the Script"! Experiment and have fun!', :order_index=>4)
    ])
  end










end