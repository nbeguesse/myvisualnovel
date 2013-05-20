class CharacterPoseEvent < Event
  belongs_to :character
  belongs_to :scene

  #on creation
  #add left or right orientation field
  #depending on which characters are already there

  #on creation
  #invalid if already two characters present

  def left_or_right
    "left"
  end

 
  # def self.folder
  #  "Character/#{character_type}"
  # end

  def image_description #e.g. "School Hallway"
  	humanize(filename)
  end

  def to_sentence
    if scene.has_character?(character, order_index-1)
  	  "<i>".html_safe+character.name+"</i> changes pose".html_safe
    else
       "<i>".html_safe+character.name+"</i> appears".html_safe
    end
  end

  def detail
    "Pose: #{humanize(filename)}".html_safe
  end

  def get_file
    "/"+File.join("Character",character_type, "Pose", filename)
  end



end