module ApplicationHelper
  def json_escape(s)
    result = s.to_s.gsub('/', '\/')
    s.html_safe? ? result.html_safe : result
  end

  def coolify(text)
  	"<span class='romantic-font'>".html_safe+text.titleize+"</span>".html_safe
  end

end
