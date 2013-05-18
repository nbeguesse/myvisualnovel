class Scene < ActiveRecord::Base
  belongs_to :project
  attr_accessor :initial_event_pack
  attr_accessible :custom_description, :initial_event_pack
  has_many :events
  validates_presence_of :project
  before_validation :set_order_index, :on=>:create
  before_create :load_initial_events

  def get_description
  	return custom_description if custom_description.present?
    return sample_image.image_description
  end

  # def get_image
  #   sample_image.get_file
  # end

  def load_initial_events
    if i = self.initial_event_pack
      self.events = EventPacks.locations[i.to_i].events
    end
  end

  def set_order_index
    self.order_index ||= Scene.maximum('order_index', :conditions => { :project_id => project_id }).to_i + 1
  end

  def sample_image
    middle = (events.count.to_f/2).ceil
    image_at middle
  end

   def image_at event_index
     Event.for_scene(self).at_or_before(event_index).background_images.first || BackgroundImageEvent.default
   end

   def has_character? character, event_index
     !Event.for_scene(self).at_or_before(event_index).character_appears(character).empty?
   end

end
