class Character < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name, :project
  belongs_to :project
  before_validation :set_defaults, :on=>:create
  has_many :events, :dependent=>:destroy
  before_save :set_name
  has_many :events

  scope :by_name_and_project, lambda { |name, project| {:conditions => ["type=? and project_id=?", name.to_s, project.id]} }
  scope :without_narrator, lambda { {:conditions=>["type != ?", "Narrator"]} }

  def icon
    "/Character/#{self.type}/Icon/260x195.png"
  end


  def set_name
    if name_changed? && !self.new_record?
      Event.where(:character_id=>self.id).update_all(:character_name=>self.name)
    end
  end
  def default_name
  	self.class.to_s
  end

  def self.available_for(user)
    [Narrator, Ami, Ajax]
  end

  def self.all_available
  	[Narrator, Ami, Ajax]
  end

  def is_narrator?
    false
  end

  def get_poses(category,user)
    packs = ["Base"]
    out = []
    packs.each do |pack|
      out.concat(pose_list(category, pack))
    end
    out
  end

  PoseOption = Struct.new(:url, :title, :thumbnail, :face)
  def pose_list category="Pose", pack="Base"
   out = []
   path = File.join("Character",self.type, category, pack)
   Dir.new(File.join(Rails.root, "public", path)).each do |file|
     next if invalid_image?(file)
     url = "/"+File.join(path,file)
     thumbnail = "/"+File.join(path,"thumbnail",file)
     face = "/"+File.join("Character",self.type,"Face","Base","normal.png")
     out << PoseOption.new(url, humanize(file), thumbnail, face)
   end
   out
  end

  # def face_list pack="Base"
  #  out = []
  #  path = File.join("Character",self.type,"Face", pack)
  #  Dir.new(File.join(Rails.root, "public", path)).each do |file|
  #    next if invalid_image?(file)
  #    url = "/"+File.join(path,file)
  #    thumbnail = "/"+File.join(path,"thumbnail",file)
  #    #face = "/"+File.join("Character",self.type,"Face","normal.png")
  #    out << PoseOption.new(url, humanize(file), thumbnail)
  #  end
  #  out
  # end

  # def love_pose_list sexes = nil
  #  return [] if is_narrator?
  #  out = []
  #  #find all of the applicable M/F directories
  #  combos = [["M"],["F"],["M","M"],["F","F"]]
  #  combos.select!{|c| sexes.combination(c.length).include?(c)}
  #  combos << ["M","F"] if sexes.join.include?("FM") || sexes.join.include?("MF")
  #  #now get the file list of each directory
  #  combos.each do |folder|
  #    path = File.join("Character",self.type,folder.join,"Intimate")
  #    complete_path = File.join(Rails.root, "public", path)
  #    next unless File.exist? complete_path
  #    Dir.new(complete_path).each do |file|
  #      next if invalid_image?(file)
  #      url = "/"+File.join(path,file)
  #      thumbnail = url
  #      out << PoseOption.new(url, humanize(file), url)
  #    end
  #  end
  #  out
  # end

  def humanize name
    self.class.humanize name
  end

  def self.humanize name
    File.basename(name, File.extname(name)).humanize.titleize
  end


  def invalid_image? file
    return true if file == "."
    return true if file == ".."
    return true if file.include?("DS_Store")
    return true if file == "thumbnail"
    return false
  end
protected
  def set_defaults
  	self.name = self.default_name
    self.sex = self.default_sex
  end
end
