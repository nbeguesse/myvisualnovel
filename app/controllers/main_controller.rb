class MainController < ApplicationController
  
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
