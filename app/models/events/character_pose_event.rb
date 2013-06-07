class CharacterPoseEvent < Event
  belongs_to :character
  belongs_to :scene
  after_save :check_existence

  def check_existence
    if filename.blank? && !scene.has_character?(character, order_index-1)
      #i.e. only a face with no body
      self.destroy
    end
  end
 
  # def self.folder
  #  "Character/#{character_type}"
  # end

  # def image_description #e.g. "School Hallway"
  # 	humanize(filename)
  # end

  # def effect_on_characters_present arr
  #     if scene && scene.love_scene?
  #       arr[1] = [character_id, filename, subfilename]
  #       return arr    
  #     end
  #     if arr[1] && arr[1][0]==character_id #character in position 1
  #       arr[1][1] = filename
  #       arr[1][2] = subfilename
  #     elsif arr[2] && arr[2][0]==character_id #character in position 2
  #       arr[2][1] = filename
  #       arr[2][2] = subfilename
  #     elsif arr[1].nil?
  #       arr[1] = [character_id, filename, subfilename]
  #     elsif arr[2].nil?
  #       arr[2] = [character_id, filename, subfilename]
  #     else
  #       #TODO: Throw error if already 2 chars present
  #       #arr << [character_id, filename]
  #     end
  #     arr
  # end

  def to_sentence
    if scene.has_character?(character, order_index-1)
  	  "<i>".html_safe+character_name+"</i> changes pose".html_safe
    else
       "<i>".html_safe+character_name+"</i> appears".html_safe
    end
  end

  def detail
    out = ""
    if scene.love_scene?
      out << "Pose: #{humanize(filename)} ".html_safe
    else
      out << "Clothes: #{humanize(filename)} /".html_safe if filename
    end
    out << "Face: #{humanize(subfilename)}" if subfilename.present?
    out
  end

  # def get_file
  #   "/"+File.join("Character",character_type, "Pose", filename)
  # end



end