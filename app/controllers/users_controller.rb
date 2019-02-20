class UsersController < ApplicationController
  #These potenitally do the same thing?
  before_action :require_login, only: [:show, :edit]
  before_action :require_current_user, only: [:show, :edit]

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

  def show
    @user = current_user
    @orders = @user.orders
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(user_params)
      redirect_to profile_path
    else
      flash[:error] = "That email has already been taken."
      redirect_to profile_edit_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :street_address, :city, :zip_code, :state, :password_confirmation)
  end

  def require_login
    unless logged_in?
      flash[:error] = "The page you were looking for doesn't exist."
      redirect_to 'public/404'
    end
  end

  # remove - same as current_user
  def logged_in?
    if session[:user_id]
      true
    end
  end


end
