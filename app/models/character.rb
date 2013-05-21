class Character < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name, :project
  belongs_to :project
  before_validation :set_defaults, :on=>:create
  has_many :events, :dependent=>:destroy

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

  PoseOption = Struct.new(:url, :title, :thumbnail)
  def self.pose_list
   out = []
   path = File.join("Character",self.to_s,"Pose")
   Dir.new(File.join(Rails.root, "public", path)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     next if file == "thumbnail"
     next if file == "reverse"
     url = "/"+File.join(path,file)
     thumbnail = "/"+File.join(path,"thumbnail",file)
     out << PoseOption.new(url, humanize(file), thumbnail)
   end
   out
  end

  def self.humanize name
    File.basename(name, File.extname(name)).humanize.titleize
  end

protected
  def set_defaults
  	self.name = self.default_name
    self.description = self.default_description
  end
end
