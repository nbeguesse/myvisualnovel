class Scene < ActiveRecord::Base
  belongs_to :project
  attr_accessor :initial_event_pack
  attr_accessible :custom_description, :initial_event_pack
  has_many :events
  validates_presence_of :project
  before_validation :set_order_index, :on=>:create
  #after_create :load_initial_events #doesnt work

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
     last_appearance = Event.for_scene(self).at_or_before(event_index).character_pose(character)
     return false if last_appearance.empty?
     last_vanishing =  Event.for_scene(self).at_or_before(event_index).character_vanishes(character)
     return true if last_vanishing.empty?
     last_appearance.first.order_index > last_vanishing.first.order_index
   end

   def character_poses event_index
     out = []
     project.characters.each do |char|
       last_appearance = Event.for_scene(self).at_or_before(event_index).character_pose(char)
       next if last_appearance.empty?
       last_vanishing =  Event.for_scene(self).at_or_before(event_index).character_vanishes(char)
       if last_vanishing.empty? || last_appearance.first.order_index > last_vanishing.first.order_index
         out << last_appearance.first
       end
     end
     out
   end

end
