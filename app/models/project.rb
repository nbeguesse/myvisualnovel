class Project < ActiveRecord::Base
   attr_accessible :title, :public
   before_create :setup_data
   has_many :characters
   has_many :scenes
   validates_presence_of :title

   def default_title
   	"Dream Date"
   end

protected
   def setup_data
   	  self.characters << Hitomi.new
   	  self.characters << Narrator.new
   end
end
