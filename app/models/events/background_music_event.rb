class BackgroundMusicEvent < Event

  EventOption = Struct.new(:url, :title, :category)
  def self.file_list(user = nil)
   out = []
   packs = ["Base","Romantic"]
   packs.each do |pack|
     Dir.new(File.join(Rails.root, "public", folder, pack)).each do |file|
       next if invalid_file? file
       url = "/"+File.join(folder,pack,file)
       out << EventOption.new(url, humanize(file), pack.downcase)
     end
   end
   out
  end

  def self.folder
    "BackgroundMusic"
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