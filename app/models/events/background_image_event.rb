class BackgroundImageEvent < Event

  EventOption = Struct.new(:filename, :image_url, :title)
  def self.file_list(category="")
   out = []
   Dir.new(File.join(Rails.root, "public", self.folder, category)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     url = "/"+File.join(folder,file)
     out << EventOption.new(file, url, humanize(file))
   end
   out
  end
  
  def self.folder
   "BackgroundImage"
  end

  def self.default
  	self.new(:filename=>"black.jpg")
  end

  def image_description #e.g. "School Hallway"
  	humanize(filename)
  end

  def to_sentence
  	"<span class='muted'>Background changed to <i class='text-info'>#{image_description}</i></span>".html_safe
  end

end