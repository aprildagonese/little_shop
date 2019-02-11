class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.registered?
        redirect_to profile_path
      elsif user.merchant?
        redirect_to dashboard_path
      elsif user.admin?
        redirect_to items_path
      end
    else
      flash[:alert] = "Name and email already taken. Must be unique"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:alert] = "You are logged out."
    redirect_to welcome_path
  end

end
