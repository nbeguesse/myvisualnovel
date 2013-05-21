class UserSessionsController < ApplicationController
  ssl_required :create
  ssl_allowed :destroy

  skip_before_filter :ensure_user_not_blocked
  skip_before_filter :require_user

  before_filter :require_user, :only => [:destroy]
  def debug
    @request = request.session_options
  end

  def new
    redirect_to root_url and return
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    logger.info "USER LOGIN. User try to login with params with login #{params[:user_session][:email]} and remember me #{params[:user_session]["remember_me"]}"

    session[:return_to] = nil
    if @user_session.save
      if @user_session.record.may_login?

        #copy objects in the TempSession to the user
        email = params[:user_session][:email]
        temp_session = TempSession.new(request.session_options) 
        user = User.find_by_email(email)
        temp_session.copy_to(user) 
        #flash[:notice] = "Welcome back, #{user.first_name}!" if user.first_name.present?
        redirect_to new_car_path
      else
        logger.info "USER LOGIN. User failed to login but he was #{@user_session.record.present? && @user_session.record.blocked ? I18n.t('login.user_blocked') : I18n.t("errors.login.not_activated_dealer") } with params #{params.inspect} "
        flash[:error] = @user_session.record.present? && @user_session.record.blocked ? I18n.t('login.user_blocked') : I18n.t("errors.login.not_activated_dealer")
        @user_session.destroy
        redirect_to root_url
      end
    else
      logger.info "USER LOGIN. User failed to login with params #{params.inspect} and error #{@user_session.errors.full_messages.join(" | ")}"
      flash[:error] = "Incorrect email or password. Please try again."
      redirect_to root_url
    end
  end

  def destroy
    set_other_user_as_current nil
    current_user.reset_persistence_token
    current_user_session.destroy
    if params[:redirect]
      redirect_to params[:redirect]
    else
      flash[:notice] = ['QRVin.com', I18n.t('common.logout_success')]
      redirect_to root_url
    end
  end

  def show
    redirect_to root_path
  end

  def about

  end
end
