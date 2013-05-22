class UsersController < ApplicationController
  ssl_allowed :destroy
  ssl_required :create, :update, :edit, :change_password, :join

  skip_before_filter :require_user

  before_filter :require_user, :only => [:edit, :update]
  # before_filter :may_delete_user, :only => [:destroy]
  # before_filter :billing_view, :only =>[:billing]

  # def settings
  #   #Changes the settings for ALL of the qr tags
  #   @current_nav_point = "settings"
  #   @window_label = session_obj.window_label
  #   @qr_label = session_obj.qr_label
  #   if request.post?
  #     @qr_label.update_attributes(params[:qr_label])
  #     @window_label.update_attributes(params[:window_label])
  #     #if params[:user] && !params[:user][:logo].blank?
  #     current_user.update_attributes(params[:user]) if logged_in?
  #     #end
  #     redirect_to list_cars_path and return
  #   end
  # end

  def new
    @user = User.new
  end


  def create
    @user = User.new(params[:user])

    if @user.save
        @user_session = UserSession.new(:email=>params[:user][:email], :password=>params[:user][:password])
        @user_session.save
        session_obj.copy_to(@user)
        flash[:notice] = "Thanks for signing up! You're ready to start making your own visual novels."
        redirect_to root_url
    else
      flash[:error] = "-- " + @user.errors.full_messages.join('<br/> -- ')
      render :action => :new
    end
  end



  def change_password
    @user = User.find params[:id]
    User.transaction do
      unless @user.update_attributes(params[:user])
        flash[:error] = error_messages_as_string @user
      end
    end
    redirect_to :back
  end
  
  protected
  def get_user
    if current_user.has_admin_or_mgt_role?
      @user = User.find(params[:id])  
    else
      @user = current_user
    end

  end

end
