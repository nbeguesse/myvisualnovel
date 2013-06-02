class LovePoseEvent < BackgroundImageEvent
  # belongs_to :character
  # belongs_to :scene
 # before_save :set_bg
 
   def self.folder
    "/LovePose/Base"
   end

  # def get_file
  #   subfilename || BackgroundImageEvent.default.get_file
  # end

  # def self.bg_attribute
  #   "subfilename"
  # end

  # def set_bg
  #   if subfilename && subfilename_changed?
  #     characters_present[0] = ["BG", self.subfilename]
  #   end
  # end





end