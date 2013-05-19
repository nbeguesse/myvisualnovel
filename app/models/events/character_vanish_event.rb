class CharacterVanishEvent < Event
  belongs_to :character
  belongs_to :scene
  after_save :check_existence

  def to_sentence
    "<span class='muted'><i class='name'>#{character.name}</i> vanishes</span>".html_safe
  end

  def check_existence
    if !scene.has_character? character, order_index-1
      self.destroy
    end
  end



end