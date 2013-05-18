class Character < ActiveRecord::Base
  validates_presence_of :name, :project
  belongs_to :project
  before_validation :set_defaults, :on=>:create

  scope :by_name_and_project, lambda { |name, project| {:conditions => ["type=? and project_id=?", name.to_s, project.id]} }


  def default_name
  	self.class.to_s
  end
  def default_description
    ""
  end
  def self.all_available
  	[Narrator, Hitomi]
  end

  def is_narrator?
    false
  end

protected
  def set_defaults
  	self.name = self.default_name
    self.description = self.default_description
  end
end
