class Event < ActiveRecord::Base
  belongs_to :scene
  attr_accessible :filename, :order_index
  validates_presence_of :type
  before_create :set_order_index
  before_validation :set_order_index, :on=>:create

  def self.file_list(category=nil)
  	out = []
  	Dir.new(File.join(Rails.root, "public", self.folder, category)).each do |file|
  	  next if file == "."
  	  next if file == ".."
  	  out << file
  	end
  	out
  end

  def get_file
    "/"+File.join(self.folder, self.filename)
  end

  def self.folder
    "No Folder"
  end

  def folder
    self.class.folder
  end

  def set_order_index
    self.order_index = Event.maximum('order_index', :conditions => { :scene_id => scene_id }).to_i + 1
  end


end
