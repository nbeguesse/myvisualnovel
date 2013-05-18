class Event < ActiveRecord::Base
  belongs_to :scene
  attr_accessible :filename, :order_index, :type
  validates_presence_of :type
  before_create :set_order_index
  before_validation :set_order_index, :on=>:create

  #scope :latest, lambda { {:order=>"order_index DESC", :limit=>1} }
  scope :ordered,  lambda { {:order=>"order_index ASC"} }
  scope :at_or_before, lambda { |order_index| {:conditions => ["order_index <= ?", order_index], :order=>"order_index DESC", :limit=>1} }
  scope :for_scene, lambda { |scene| {:conditions => ["scene_id=? ", scene.id] } }
  scope :background_images, lambda {{:conditions=>["type=?","BackgroundImageEvent"]}}
  scope :character_appears, lambda { |character| {:conditions=>["type=? and character_id=?","CharacterAppearsEvent", character.id]}}

  def self.file_list(category="")
   out = []
   Dir.new(File.join(Rails.root, "public", self.folder, category)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     out << "/"+File.join(folder,file)
   end
   out
  end

  def get_file
    "/"+File.join(self.folder, self.filename)
  end

  def self.folder
    "No Folder"
  end

  def folder
    self.class.folder
  end

  def set_order_index
    self.order_index ||= Event.maximum('order_index', :conditions => { :scene_id => scene_id }).to_i + 1
  end

  def self.humanize name
    File.basename(name, File.extname(name)).humanize.titleize
  end

  def humanize name
    self.class.humanize name
  end


end
