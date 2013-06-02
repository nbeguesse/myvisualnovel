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
  before_save :partial_set_characters_present

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

  def partial_set_characters_present
    if !new_record? && (filename_changed? || subfilename_changed?)
      previous_event = Event.for_scene(scene).at(order_index-1).first
      set_characters_present previous_event
      all = scene.events.ordered.to_a
      all.shift order_index
      prev = self
      all.each_index do |i|
          event = all[i]
          event.set_characters_present prev
          if event.changed?
            event.save
          else
            break
          end
          prev = event
      end
    end
  end

  def effect_on_characters_present arr
    arr
  end

  def set_characters_present prev
    arr = prev.try(:characters_present) || []
    arr[0] ||= ["BG", BackgroundImageEvent.default.get_file]
    self.characters_present = effect_on_characters_present(arr)
  end

  def set_character_type
    if character_id
      self.character_type = character.type
      self.character_name = character.name
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
    character_name
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
      return true if chars[1] && chars[1][0]==character.id
      return true if chars[2] && chars[2][0]==character.id
     end
     return false
  end
  def self.invalid_file? file
    return true if file == "."
    return true if file == ".."
    return true if file.include?("DS_Store")
    return false
  end


end
