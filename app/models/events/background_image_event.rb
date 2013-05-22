class BackgroundImageEvent < Event


  EventOption = Struct.new(:url, :title)
  def self.file_list(user=nil)
   out = []
   Dir.new(File.join(Rails.root, "public", self.folder)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     url = File.join(folder,file)
     out << EventOption.new(url, humanize(file))
   end
   out
  end

  def self.folder
   "/BackgroundImage/Base"
  end

  def self.default
  	self.new(:filename=>"#{folder}/black.jpg")
  end

  def image_description #e.g. "School Hallway"
  	humanize(filename)
  end

  def to_sentence
  	"[Scene: <i>".html_safe+image_description+"</i>]".html_safe
  end

end