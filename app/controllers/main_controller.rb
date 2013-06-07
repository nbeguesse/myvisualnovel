class MainController < ApplicationController
  #before_filter :set_access_control_headers


  def cookie
    set_adult_cookie
    redirect_to params[:redirect_to] || root_url
  end
  
  def not_found
  	
  end

  def forum
    @backlink = root_path

    api_key = "r66MDumZy08VXMs9gJS2Lz3Ko9cVGQB00iv08DsHHkSOFs6T8kw0WsZEvJ5y4Aaj"
    url = "https://disqus.com/api/3.0/forums/listThreads.json?&api_key=#{api_key}&forum=mvnforum2&limit=100"
    @http = Net::HTTP.new('disqus.com')  
    @http = @http.start    
    req = Net::HTTP::Get.new(URI.encode(url))
    res = @http.request(req) 
    @posts = res.body.html_safe


  	
  end

  def index
  	@nextlink = new_project_path
  	@body_class="homepage"
    @page_title = "Create your own Visual Novels Fast and Easy. What will you do?"
  end

end
