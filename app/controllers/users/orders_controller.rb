class Users::OrdersController < ApplicationController
  before_action :require_current_user

  def show
    @order = Order.find(params[:id])
  end

  def index
    @user = User.find(session[:user_id])
    @orders = Order.where(user_id: @user)
  end

  def update
    @order = Order.find(params[:order_id])
    @order.change_status
    redirect_to profile_orders_path
  end

  def destroy
    order = Order.find(params[:order_id])
    @user = order.user
    order.cancel
    order.save
    redirect_to profile_orders_path
    flash[:notice] = "Order #{order.id} has been cancelled."
  end

end
