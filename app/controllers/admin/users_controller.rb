class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
  end

  def index
  end

  def edit
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
