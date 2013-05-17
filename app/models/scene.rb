class Scene < ActiveRecord::Base
  belongs_to :project
  attr_accessor :location
  attr_accessible :custom_description, :location
  has_many :events
  validates_presence_of :project
  before_validation :set_order_index, :on=>:create

  def get_description
  	custom_description
  end


  def set_order_index
    self.order_index = Scene.maximum('order_index', :conditions => { :project_id => project_id }).to_i + 1
  end
end
