class UsersController < ApplicationController
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
      render :new
    end
  end

  def index
    @users = User.all
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
