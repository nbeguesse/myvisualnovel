class PreloadEvent < Event

  def fill_data(s)
  	self.characters_present = s.events.ordered.map{|event| [event.filename, event.subfilename]}.flatten.compact
  	return self
  end


end