class CharacterSpeaksEvent < Event
  belongs_to :character
  belongs_to :scene


  def to_sentence
    "<i>".html_safe+character.name+"</i> speaks".html_safe
  end

  def get_text
  	"&ldquo;".html_safe+self.text+"&rdquo;".html_safe
  end

  def detail
    get_text
  end

  def glassbox?
  	true
  end



end