class CharacterVanishEvent < Event
  belongs_to :character
  belongs_to :scene
  after_save :check_existence

  def to_sentence
     "<i>".html_safe+character_name+"</i> vanishes".html_safe
  end

  def check_existence
    if !scene.has_character? character, order_index-1
      self.destroy
    end
  end
  def effect_on_characters_present arr
      if arr[1][0] == character_id
        arr[1] = nil
      elsif arr[2][0] == character_id
        arr[2] = nil
      else
        arr.reject!{|e|e[0]==character_id}
      end
      arr
  end


end