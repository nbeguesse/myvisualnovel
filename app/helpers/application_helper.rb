module ApplicationHelper
  def has_adult_cookie?
    !cookies[:adult].blank?
  end
  def json_escape(s)
    result = s.to_s.gsub('/', '\/')
    s.html_safe? ? result.html_safe : result
  end

  def coolify(text)
  	"<span class='romantic-font'>".html_safe+text.titleize+"</span>".html_safe
  end

  def wrap_title title
  	"MyVisualNovel | #{title}"
  end

  def humanize_title path
    #Rails.logger.info "PATH IS"+ path
    if ( path =~ /\/projects\/\d+\/edit/ )
     return "Customize"
    elsif ( path =~ /\/projects\/\d+\/characters/ )
      return "Edit Characters"
    elsif ( path =~ /\/projects\/\d+\/scenes\// )
      return "#{@project.title} : #{@scene.get_description}" rescue return "Edit Script"    
    elsif ( path =~ /\/projects\/\d+/ )
      return "Edit My Novel"
    elsif ( path =~ /\/projects\/new/ )
      return "START"
    elsif ( path =~ /\/projects/ )
      return "My Novels"
    elsif ( path =~ /\/play\/\d+/ ) && @only_scene
      return "Preview: "+@scenes[0].get_description
    elsif ( path =~ /\/play\/\d+/ )
      return @project.title
    elsif path == "/forum"
      return "Forum"
    elsif path == "/"
      return "Home"
    end
    (@path_params[:action] + " "+ @path_params[:controller]).titleize.gsub("Index ","").gsub("Project","Novel")
  
  end


end
