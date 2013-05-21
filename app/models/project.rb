class Project < ActiveRecord::Base
   attr_accessible :title, :public, :character_ids
   before_create :setup_data
   has_many :characters
   has_many :scenes
   validates_presence_of :title
   before_save :set_basename

   def default_title
   	"Dream Date"
   end
   def play_path
      "/play/#{id}/#{basename}"
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
