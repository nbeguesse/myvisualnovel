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
  	  "<span class='muted'><i class='name'>#{character.name}</i> changes pose</span>".html_safe
    else
      "<span class='muted'><i class='name'>#{character.name}</i> appears</span>".html_safe
    end
  end

  def detail
    "<br/><small>#{humanize(filename)}</small>".html_safe
  end

  def get_file
    "/"+File.join("Character",character_type, "Pose", filename)
  end

end