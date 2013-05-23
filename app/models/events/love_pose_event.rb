class LovePoseEvent < BackgroundImageEvent
  belongs_to :character
  belongs_to :scene
  after_save :set_subfilename
 
  def self.folder
   "/LoveImage/Base"
  end

  def detail
    "Background: #{humanize(subfilename || "None")}".html_safe
  end

  def get_file
    subfilename || BackgroundImageEvent.default.get_file
  end

  def self.bg_attribute
    "subfilename"
  end

  def set_subfilename
    if subfilename.blank? && prev_event = Event.for_scene(scene).at_or_before(self.order_index-1).love_poses.first
      self.update_attribute(:subfilename, prev_event.subfilename)

    end
  end



end