class Gymnasium

  def self.name
  	"Gymnasium"
  end

  def self.events
    [background_image]
  end

  def self.background_image
  	BackgroundImageEvent.new(:filename => "car1.jpg")
  end

end