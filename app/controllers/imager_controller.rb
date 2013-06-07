require 'fileutils'
class ImagerController < ApplicationController

  def get
    #e.g. http://localhost:3000/i?bg=/BackgroundImage/Base/school_roof.jpg&character1=/Character/Ami/Pose/Base/blouse.png&face1=/Character/Ami/Face/Base/happy.png&character2=/Character/Ajax/Pose/Base/sweater.png&face2=/Character/Ajax/Face/Base/happy.png
    src_path = File.join(Rails.root, "public") #rote to public directory
    background_filename = params[:bg]
    
    outpath = [src_path,"Compiled",substitute(background_filename)]
    if params[:character1]
      outpath << "1"+substitute(params[:character1])
      outpath << "1"+substitute(params[:face1]) if params[:face1]
    end
    if params[:character2]
      outpath << "2"+substitute(params[:character2])
      outpath << "2"+substitute(params[:face2])
    end
    outpath = File.join(outpath)+".jpg"
    if !File.exist?(outpath)
      directory = File.dirname(outpath)
      FileUtils.mkpath(directory) 
      image = MiniMagick::Image.open src_path+background_filename
      if params[:character1]
        character = MiniMagick::Image.open src_path+params[:character1]
        result = image.composite(character) { |c| c.compose "Over" }
        if params[:face1]
          face = MiniMagick::Image.open src_path+params[:face1]
          result = result.composite(face) { |c| c.compose "Over" }
        end
        image = result
      end
      if params[:character2]
        character = MiniMagick::Image.open src_path+params[:character2]
        face = MiniMagick::Image.open src_path+params[:face2]
        result = image.composite(character) { |c| c.compose "Over"; c.geometry "+400+00" }
        result = result.composite(face) { |c| c.compose "Over"; c.geometry "+400+00" }
        image = result
      end
      
      #Rails.logger.info outpath
      image.format "jpg"
      image.quality 70
      image.write outpath


    else
      image = MiniMagick::Image.open outpath
    end
    if params[:width] #resize the image thumbnail. Only really necessary for ie
      height = params[:width].to_i*600/800
      image.resize "#{params[:width]}x#{height}"
    end
    send_data(image.to_blob, :type=>"image/jpg", :disposition=>'inline')
  end

  def substitute string #make dirname out of pathname
    string[1..-1].gsub("/","-").gsub(".png","").gsub(".jpg","")
  end


end
