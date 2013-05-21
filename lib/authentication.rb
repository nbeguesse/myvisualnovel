module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user_session, :current_user, :logged_in?, :other_user_as_current, :set_other_user_as_current, :other_user_as_current?, :current_actual_user

  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)
    return unless current_user_session.present?
    if other_user_as_current?
      @current_user = User.find other_user_as_current
    else
      @current_user = current_user_session.user
    end
    @current_user
  end

  def current_actual_user
    return @current_actual_user if defined?(@current_actual_user)
    @current_actual_user = current_user_session.user if current_user_session
  end


  def require_user
    Rails.logger.info "in require user"
    if token = params[:single_access_token]
      Rails.logger.info "found token"
      if user = User.find_by_single_access_token(token)
        Rails.logger.info "found user"
        @current_user = user
        @current_actual_user = user
      end
    end
    unless current_user
      flash[:error] = I18n.t("login.not_logged_in")
      session[:return_to] = request.fullpath
      redirect_to login_url
    end
  end


  # def require_user_or_visitor
  #   unless logged_in? || visitor?
  #     flash[:error] = I18n.t("login.not_logged_in")
  #     session[:return_to] = request.request_uri
  #     redirect_to login_url
  #   end
  # end

  # def visitor?
  #    !logged_in? && current_visitor.present?
  # end

  # def current_visitor
  #   return @current_visitor if defined?(@current_visitor)
  #   return nil if cookies[:visitor].blank?
  #   #Visitor.find_by_secret_code(cookies[:visitor])
  # end

  def set_other_user_as_current(user_id)
    session[:other_user_id] = user_id
  end

  def other_user_as_current
    session[:other_user_id]
  end

  def other_user_as_current?
    session[:other_user_id].present?
  end

  def require_no_user
    if current_user
      store_location
      flash[:error] = "You should logout"
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] =
    if request.get?
      request.fullpath
    else
      request.referer
    end
  end

  def redirect_back_or_default(default, *options)
    return_to = session[:return_to]
    session[:return_to] = nil
    tag_options = {}
    options.first.each { |k,v| tag_options[k] = v } unless options.empty?
    redirect_to(return_to || request.headers["Referer"] || default, tag_options)
  end
end


#ActionController::Base.class_eval do
#  def log_processing_with_user
#    log_processing_without_user
#    if logger && logger.info?
#      if current_user.present?
#        logger.info "Action performed by: Current user - login: #{current_user.email} id: #{current_user.id} Current actual user -  login: #{current_actual_user.email} id:#{current_actual_user.id}"
#      else
#        logger.info "Action performed by: Not logged_in user"
#      end
#    end
#  end
#
#  alias_method_chain :log_processing, :user
#end