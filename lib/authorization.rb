module Authorization
  def self.included(controller)
    controller.send :helper_method, :check_tos, :admin_only
  end

  def redirect_to_403
    logger.info ""
    if current_actual_user.try(:may_access_admin_zone?)
      flash[:error] ||= "Permission denied. Please choose correct user"
      redirect_to root_url
    else
      redirect_to "/403.html"
    end
  end

  def check_tos
    return if current_user.nil? || current_user.blank?
    unless current_user.try(:may_need_to_accept_terms_of_conditions?)
      store_location
      redirect_to tos_url
    end
  end

  def admin_only
    unless current_actual_user.try(:may_admin_only?)
      redirect_to_403
    end
  end
  def redirect_to_404
    redirect_to "/404.html"
  end
end