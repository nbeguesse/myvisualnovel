class PreloadEvent < Event

  def fill_data(s)
  	self.text = s.events.ordered.map{|event| PreloadEvent.compiled_image(event)}.flatten.compact
  	return self
  end

  def self.compiled_image event
    c = event.characters_present
    return BackgroundImageEvent.default.filename if c.blank?
    #if [BackgroundImageEvent, LovePoseEvent, CharacterPoseEvent].include?(event.type.constantize)
      para = {}
      para[:bg] = c.try(:first).try(:second)
      para[:character1] = c.try(:second).try(:second)
      para[:face1] = c.try(:second).try(:third)
      para[:character2] = c.try(:third).try(:second)
      para[:face2] = c.try(:third).try(:third)    
      return Rails.application.routes.url_helpers.imager_path(para)
    #end
    #return BackgroundImageEvent.default.filename
  end


end