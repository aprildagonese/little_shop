class SessionsController < ApplicationController
  helper_method :is_logged_in

  def new
    if current_user
      is_logged_in
    end
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
      flash[:alert] = "Login failed. Please check your email address and password."
      render :new
    end
  end

  def destroy
    session.clear
    flash[:alert] = "You are logged out."
    redirect_to welcome_path
  end


  private

  def is_logged_in
    if current_user.role == 'registered'
      redirect_to profile_path
      flash[:alert] = "You are aleady logged in."
    elsif current_user.role == "merchant"
      redirect_to dashboard_path
      flash[:alert] = "You are aleady logged in."
    elsif current_user.role == "admin"
      redirect_to items_path
      flash[:alert] = "You are aleady logged in."
    end
  end

end
