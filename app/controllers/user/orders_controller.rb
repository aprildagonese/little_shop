class User::OrdersController < ApplicationController
  before_action :require_current_user

  def show
    @order = Order.find(params[:order_id])
  end

  def index
    @user = User.find(session[:user_id])
  end

  def update
    @order = Order.find(params[:order_id])
    @order.change_status
    redirect_to profile_orders_path
  end

end
