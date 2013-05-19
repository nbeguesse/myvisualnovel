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
  	"Background changed to <i>".html_safe+image_description+"</i>".html_safe
  end

end