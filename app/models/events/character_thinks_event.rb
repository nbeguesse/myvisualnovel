class CharacterThinksEvent < Event
  belongs_to :character
  belongs_to :scene

  def to_sentence
    "".html_safe+character.name.upcase+" (thinking):".html_safe
  end

  def get_text
  	"<i class='thought'>(".html_safe+self.text+")</i>".html_safe
  end

  def detail
    get_text
  end

  def glassbox?
  	true
  end



end