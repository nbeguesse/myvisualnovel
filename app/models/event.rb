class Event < ActiveRecord::Base
  belongs_to :scene
  belongs_to :character
  attr_accessible :filename, :order_index, :type, :character_id, :text
  validates_presence_of :type
  before_create :set_order_index
  before_validation :set_order_index, :on=>:create
  before_validation :set_character_type, :on=>:create
  after_create :check_duplicate_indexes
  after_destroy :reorder_indexes

  #scope :latest, lambda { {:order=>"order_index DESC", :limit=>1} }
  scope :ordered,  lambda { {:order=>"order_index ASC, id ASC"} }
  scope :at_or_before, lambda { |order_index| {:conditions => ["order_index <= ?", order_index], :order=>"order_index DESC", :limit=>1} }
  scope :for_scene, lambda { |scene| {:conditions => ["scene_id=? ", scene.id] } }
  scope :background_images, lambda {{:conditions=>["type=?","BackgroundImageEvent"]}}
  scope :character_pose, lambda { |character| {:conditions=>["type=? and character_id=?","CharacterPoseEvent", character.id]}}
  scope :character_vanishes, lambda { |character| {:conditions=>["type=? and character_id=?","CharacterVanishEvent", character.id]}}

  EventOption = Struct.new(:filename, :image_url, :title)
  def self.file_list(category="")
   out = []
   Dir.new(File.join(Rails.root, "public", self.folder, category)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     url = "/"+File.join(folder,category,file)
     out << EventOption.new(file, url, humanize(file))
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

  def set_character_type
    if character_id
      self.character_type = character.type
    end
  end

  def self.humanize name
    File.basename(name, File.extname(name)).humanize.titleize
  end

  def humanize name
    self.class.humanize name
  end

  def reorder_indexes
    all = scene.events.ordered.to_a
    all.each_index do |i|
      all[i].update_attribute(:order_index, i+1)
    end
  end

  def check_duplicate_indexes
    reorder_indexes if Event.where(:order_index=>self.order_index).for_scene(scene).count > 1
  end

  def detail
    nil
  end

  def glassbox?
    false
  end

  def get_text
    ""
  end


end
