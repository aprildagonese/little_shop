class UsersController < ApplicationController
  #These potenitally do the same thing?
  before_action :require_login, only: [:show]
  before_action :require_current_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:message] = "Thank you for registering! You are now logged in."
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      #TODO add helper method
      flash[:alert] = "Your account could not be created with those credentials. Please try again or log in with an existing account."
      @user.email = ""
      render :new
    end
  end

  def index
    @users = User.all
  end

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
    params.require(:user).permit(:name, :email, :password, :street_address, :city, :zip_code, :state, :password_confirmation)
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section" #remove - just render 404
      redirect_to login_path #render file: '/public/404' unless current_user
    end
  end

  # remove - same as current_user
  def logged_in?
    if session[:user_id]
      true
    end
  end

  # def password_confirmed?
  #   match = params[:user][:password] == params[:user][:confirm_password]
  #   flash[:notice] = "Your passwords didn't match!" unless match
  #   match
  # end

end
