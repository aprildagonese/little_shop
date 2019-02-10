class Profile::UsersController < ApplicationController
  #These potenitally do the same thing?
  before_action :require_login, only: [:show]
  before_action :require_current_user

  def show
    #current_user instead
    #@user = User.find(params[:id])
  end

  def edit
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def logged_in?
    if session[:user_id]
      true
    end
  end

  # def require_registered
  #   render file: "/public/404" unless current_registered?
  # end
end
