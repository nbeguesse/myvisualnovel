class Scene < ActiveRecord::Base
  belongs_to :project
  attr_accessor :initial_event_pack
  attr_accessible :custom_description, :initial_event_pack
  has_many :events
  validates_presence_of :project
  before_validation :set_order_index, :on=>:create

  scope :ordered,  lambda { {:order=>"order_index ASC, id ASC"} }

  def get_description
  	return custom_description if custom_description.present?
    return sample_image.image_description
  end

  def load_initial_events
    if i = self.initial_event_pack
      self.events = EventPacks.locations[i.to_i].events
    end
  end

  def set_order_index
    self.order_index = Scene.maximum('order_index', :conditions => { :project_id => project_id }).to_i + 1
  end

  def middle_index
    (events.count.to_f/2).ceil
  end

  def sample_image
    image_at middle_index
  end

   def image_at event_index
     Event.for_scene(self).at_or_before(event_index).background_images.first || BackgroundImageEvent.default
   end

   def has_character? character, event_index
     chars = Event.for_scene(self).at(event_index).first.try(:characters_present)
     if chars
      return true if chars[0] && chars[0][0]==character.id
      return true if chars[1] && chars[1][0]==character.id
     end
     return false
   end

   def get_ordered_events
    events.ordered.concat([SceneEndEvent.new])
   end

end
