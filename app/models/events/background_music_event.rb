class BackgroundMusicEvent < Event

  EventOption = Struct.new(:url, :title)
  def self.file_list(user = nil)
   out = []
   #out << EventOption.new("","Silence (no music)")
   Dir.new(File.join(Rails.root, "public", self.folder)).each do |file|
     next if file == "."
     next if file == ".."
     next if file.include?("DS_Store")
     url = "/"+File.join(folder,file)
     out << EventOption.new(url, humanize(file))
   end
   out
  end
  
  def self.folder
   "BackgroundMusic/Base"
  end


  def music_description #e.g. "School Hallway"
  	humanize(filename)
  end

  def to_sentence
    if !filename.blank?
  	"[Music: <i>".html_safe+music_description+"</i>]".html_safe
    else
      "[Music stops]"
    end
  end

end