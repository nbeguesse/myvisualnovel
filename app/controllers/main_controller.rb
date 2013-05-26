class MainController < ApplicationController
  
  def forum
  	
  end

  def index
  	@nextlink = new_project_path
  	@body_class="homepage"
  end

end
