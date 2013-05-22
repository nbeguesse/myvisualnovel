class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentication
  include Authorization
  include ::SslRequirement
  
  helper_method :secure?
  helper :all

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

  # def coolify(text)
  #   "<span class='romantic-font'>".html_safe+text.titleize+"</span>".html_safe
  # end
  # helper_method :coolify
end
