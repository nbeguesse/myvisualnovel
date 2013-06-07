class MainController < ApplicationController
  before_filter :set_access_control_headers
def  set_access_control_headers
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Request-Method'] = '*'
          headers['Access-Control-Allow-Headers'] = '*'
          headers['Access-Control-Allow-Credentials'] = "true"
  end

  def cookie
    set_adult_cookie
    redirect_to params[:redirect_to] || root_url
  end
  
  def not_found
  	
  end

  def forum
    @backlink = root_path


  	
  end

  def index
  	@nextlink = new_project_path
  	@body_class="homepage"
    @page_title = "Create your own Visual Novels Fast and Easy. What will you do?"
  end

end
