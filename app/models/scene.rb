class Scene < ActiveRecord::Base
  belongs_to :project
  attr_accessor :initial_event_pack
  attr_accessible :custom_description, :initial_event_pack, :love_scene
  has_many :events, :dependent=>:delete_all
  validates_presence_of :project
  before_validation :set_order_index, :on=>:create

  scope :ordered,  lambda { {:order=>"order_index ASC, id ASC"} }
  scope :for_project, lambda { |project| {:conditions => ["project_id=? ", project.id] } }


  scope :at, lambda { |order_index| {:conditions => ["order_index = ?", order_index], :limit=>1} }

  # def self.after_credits_scene
  #   s = Scene.new
  #   s.events <<  TitleCardEvent.restart
  #   s
  # end

  def move_to(order_index)
    scenes = project.scenes.to_a
    scenes.reject!{|scene|scene==self}
    scenes.insert(order_index, self)
    scenes.each_index do |i|
      scene = scenes[i]
      scene.order_index = i+1
      scene.save if scene.changed?
    end
  end

  def get_description
  	return custom_description if custom_description.present?
    out =  "#{image_at(middle_index).image_description}"
    out += " (love scene)" if love_scene?
    out
  end

  def load_initial_events
    if i = self.initial_event_pack.to_i
      scenes = EventPacks.locations(project)
      self.events = scenes[i].events
      self.custom_description = scenes[i].name
    end
  end

  def set_order_index
    self.order_index = Scene.maximum('order_index', :conditions => { :project_id => project_id }).to_i + 1
  end

  def middle_index
    (events.count.to_f/2).ceil
  end


   def image_at event_index
     if love_scene?
      Event.for_scene(self).at_or_before(event_index).love_poses.first || BackgroundImageEvent.default
     else
       Event.for_scene(self).at_or_before(event_index).background_images.first || BackgroundImageEvent.default
     end
   end

   def has_character? character, event_index
     if e = Event.for_scene(self).at(event_index).first
       return e.has_character? character
     end
     false
   end

   def get_ordered_events
    events.ordered.concat([SceneEndEvent.new])
   end

end
