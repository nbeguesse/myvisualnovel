class Project < ActiveRecord::Base
   attr_accessible :title, :public, :character_ids, :basename, :author
   before_create :setup_data
   has_many :characters, :dependent=>:destroy
   has_many :scenes, :dependent=>:destroy
   validates_presence_of :title
   before_save :set_basename
   belongs_to :owner, :polymorphic => true

   scope :for_owner, lambda { |owner| {:conditions => {:owner_id => owner.id.to_s }} }

   def default_title
   	"Dream Date"
   end
   def play_path
      "/play/#{id}/#{basename}"
   end
   def owner?(user)
     self.owner_id == user.id.to_s
     self.owner_type == user.class.to_s
   end
  def temp?
    self.owner_type.to_s != "User"
  end
  def middle_index
    (scenes.count.to_f/2).ceil
  end


protected
   def set_basename
      self.basename = self.basename.gsub("-"," ").gsub(/[^0-9A-Za-z\s]/, '').gsub(" ","-") if basename_changed?
      self.basename = self.title.gsub(/[^0-9A-Za-z\s]/, '').gsub(" ","-") if basename.nil?
   end
   def setup_data
   	  self.characters << Ami.new
   	  self.characters << Narrator.new
      self.characters << Ajax.new
   end
end
