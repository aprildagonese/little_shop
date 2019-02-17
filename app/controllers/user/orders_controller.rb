class User::OrdersController < ApplicationController
  before_action :require_current_user

  def index
    @user = User.find(session[:user_id])
    @orders = Order.where(user: @user)
  end

  # def show
  #   # @user = current_user
  #   # @orders = Order.find_by(user: current_user)
  # end

  def update
    @order = Order.find(params[:order_id])
    @order.change_status
    redirect_to profile_orders_path
  end

end
