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



end