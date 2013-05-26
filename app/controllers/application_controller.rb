class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentication
  include Authorization
  include ::SslRequirement
  before_filter :set_page_title
  before_filter :set_backlink
  helper_method :secure?
  helper :all

  def set_page_title
    @path_params=request.symbolized_path_parameters
   # @page_title =  path_params[:action] + " "+ path_params[:controller]
    @current_uri = request.env['PATH_INFO']
  end

  def set_backlink
    if params[:backlink]
      @default_nextlink = params[:backlink]
    end
  end

  def session_obj
    #for logged in user
    return current_user if logged_in? 
    #for testing only
    if Rails.env.test? && params[:session_id]
      return TempSession.new(:id=>params[:session_id]) 
    end
    #for non-logged in user
    TempSession.new(request.session_options) 
  end
  helper_method :session_obj

  
  def secure?
    !(request.local? || Rails.env.development? || Rails.env.test?)
  end

  def has_car?(vin)
    return false unless vin
    Car.find_by_vin_and_owner_id(vin, session_obj.id.to_s) 
  end  

  def ssl_required?
    return false unless secure?
    super
  end

  def not_found
    flash[:notice] = "Sorry, we couldn't find the page you are looking for."
    redirect_to not_found_path and return
  end

  def not_authorized
    flash[:notice] = "Please login as the project owner to continue."
    redirect_to not_found_path and return
  end
  # def coolify(text)
  #   "<span class='romantic-font'>".html_safe+text.titleize+"</span>".html_safe
  # end
  # helper_method :coolify
end
