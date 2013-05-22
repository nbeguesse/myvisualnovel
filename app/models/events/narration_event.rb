class NarrationEvent < Event
  belongs_to :character
  belongs_to :scene

  def to_sentence
    ""
  end

  def get_text
  	self.text
  end

  def detail
    get_text
  end

  def glassbox?
  	true
  end

  def get_character_name
    ""
  end



end