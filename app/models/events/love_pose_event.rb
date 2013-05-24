class LovePoseEvent < BackgroundImageEvent
  belongs_to :character
  belongs_to :scene
  before_save :set_bg
 
  def self.folder
   "/LoveImage/Base"
  end

  def detail
    return "" if subfilename.blank?
    "Background: #{humanize(subfilename)}".html_safe
  end

  def get_file
    subfilename || BackgroundImageEvent.default.get_file
  end

  def self.bg_attribute
    "subfilename"
  end

  def set_bg
    if subfilename && subfilename_changed?
      characters_present[0] = ["BG", self.subfilename]
    end
  end

  # def default_subfilename
  #   if prev_event = Event.for_scene(scene).at_or_before(self.order_index-1).love_poses.first
  #     return prev_event.subfilename
  #   end
  #   nil
  # end

  # def set_subfilename
  #   if subfilename.blank? 
  #     self.update_attribute(:subfilename, self.default_subfilename)

  #   end
  # end



end