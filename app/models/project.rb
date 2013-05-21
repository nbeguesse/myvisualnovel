class Project < ActiveRecord::Base
   attr_accessible :title, :public, :character_ids
   before_create :setup_data
   has_many :characters
   has_many :scenes
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
     self.owner == user
   end
  def temp?
    self.owner_type.to_s != "User"
  end

protected
   def set_basename
      self.basename ||= self.title.gsub(/[^0-9A-Za-z\s]/, '').gsub(" ","-")
   end
   def setup_data
   	  self.characters << Hitomi.new
   	  self.characters << Narrator.new
   end
end
