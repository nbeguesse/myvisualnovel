class MainController < ApplicationController

  def cookie
    set_adult_cookie
    redirect_to params[:redirect_to] || root_url
  end
  
  def not_found
  	
  end

  def forum
    @backlink = root_path
     headers['Access-Control-Allow-Origin'] = "*"

  	
  end

  def index
  	@nextlink = new_project_path
  	@body_class="homepage"
    @page_title = "Create your own Visual Novels Fast and Easy. What will you do?"
  end

end
