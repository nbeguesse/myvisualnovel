class Event < ActiveRecord::Base
  belongs_to :scene
  belongs_to :character
  attr_accessible :filename, :order_index, :type, :character_id, :text, :subfilename
  validates_presence_of :type
  before_validation :set_order_index, :on=>:create
  before_validation :set_character_type, :on=>:create
  after_create :check_duplicate_indexes
  after_destroy :reorder_indexes
  serialize :characters_present
  after_save :set_defaults

  #scope :latest, lambda { {:order=>"order_index DESC", :limit=>1} }
  scope :ordered,  lambda { {:order=>"order_index ASC, id ASC"} }
  scope :at_or_before, lambda { |order_index| {:conditions => ["order_index <= ?", order_index], :order=>"order_index DESC", :limit=>1} }
  scope :at, lambda { |order_index| {:conditions => ["order_index = ?", order_index], :limit=>1} }
  scope :for_scene, lambda { |scene| {:conditions => ["scene_id=? ", scene.id] } }
  scope :background_images, lambda {{:conditions=>["type=?","BackgroundImageEvent"]}}
  scope :love_poses, lambda {{:conditions=>["type=?","LovePoseEvent"]}}
  scope :character_pose, lambda { |character| {:conditions=>["type=? and character_id=?","CharacterPoseEvent", character.id]}}
  scope :character_vanishes, lambda { |character| {:conditions=>["type=? and character_id=?","CharacterVanishEvent", character.id]}}

  def set_defaults
    if [CharacterSpeaksEvent, CharacterThinksEvent,NarrationEvent].include?(self.type.constantize)
      if self.text.blank?
        self.update_column(:text,"...")
      end
    end
  end

  def get_file
    self.filename
  end

  def self.folder
    "No Folder"
  end

  def folder
    self.class.folder
  end

  def set_order_index
    if self.order_index.nil? || self.order_index == 0 #i.e. a blank empty scene
      self.order_index = Event.maximum('order_index', :conditions => { :scene_id => scene_id }).to_i + 1
      set_characters_present nil
    end
  end

  def set_characters_present prev
    arr = prev.try(:characters_present) || []
    if self.type=="CharacterPoseEvent"
      #TODO: Move this inside those models
      if arr[0] && arr[0][0]==character_id #character in position 1
        arr[0][1] = filename
      elsif arr[1] && arr[1][0]==character_id #character in position 2
        arr[1][1] = filename
      else
        #TODO: Throw error if too many characters present
        arr << [character_id, filename]
      end
    elsif self.type=="CharacterVanishEvent"
      #remove the char
      #TODO: replace with empty spot if 2nd character present
      arr.reject!{|e|e[0]==character_id}
    elsif self.type == "LovePoseEvent"
      arr[0] ||= []
      arr[0][0] = character_id
      arr[0][1] = filename
    end
    self.characters_present = arr
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
    prev = nil
    all.each_index do |i|
      event = all[i]
      event.order_index = i+1
      event.set_characters_present prev
      event.save if event.changed?
      prev = event
    end
  end

  def check_duplicate_indexes
    if Event.where(:order_index=>self.order_index).for_scene(scene).count > 1
      reorder_indexes 
    end
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

  def get_character_name
    character.try(:name)
  end

  def event_type #for json
    self.type
  end

  def serializable_hash(options) #remove nil values from json
    super(options).select { |_, v| v }
  end

  def has_character? character
     chars = characters_present
     if chars
      return true if chars[0] && chars[0][0]==character.id
      return true if chars[1] && chars[1][0]==character.id
     end
     return false
  end


end
