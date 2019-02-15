class User::OrdersController < ApplicationController
  before_action :require_current_user

  def index
    @user = User.find(session[:user_id])
  end

  def show
  end

end
