class Admin::OrdersController < Admin::BaseController
  before_action :require_admin

  def show
    @order = Order.find(params[:id])
  end

  def index
    @user = User.find(params[:user_id])
    @orders = Order.where(user_id: @user)
  end

  def destroy
    order = Order.find(params[:id])
    @user = order.user
    order.cancel
    order.save
    redirect_to admin_orders_path(user_id: @user)
    flash[:notice] = "Order #{order.id} has been cancelled."
  end

end
