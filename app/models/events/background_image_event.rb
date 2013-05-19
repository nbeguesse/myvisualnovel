class BackgroundImageEvent < Event

  
  def self.folder
   "BackgroundImage"
  end

  def self.default
  	self.new(:filename=>"black.jpg")
  end

  def image_description #e.g. "School Hallway"
  	humanize(filename)
  end

  def to_sentence
  	"<span class='muted'>Background changed to <i class='name'>#{image_description}</i></span>".html_safe
  end

end