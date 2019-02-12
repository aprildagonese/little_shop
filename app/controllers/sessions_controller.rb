class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.registered?
        redirect_to profile_path
        flash[:alert] = "You have been logged in as a #{user.role}"
      elsif user.merchant?
        redirect_to dashboard_path
        flash[:alert] = "You have been logged in as a #{user.role}"
      elsif user.admin?
        redirect_to items_path
        flash[:alert] = "You have been logged in as an #{user.role}"
      end
    else
      flash[:alert] = "Failed to log you in, please check name and email."
      render :new
    end
  end

  def destroy
    session.clear
    flash[:alert] = "You are logged out."
    redirect_to welcome_path
  end

end
