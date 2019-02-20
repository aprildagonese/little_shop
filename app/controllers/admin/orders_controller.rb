class Admin::OrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:id])
  end

  def index
    @user = User.find(params[:user_id])
    @orders = @user.orders
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
