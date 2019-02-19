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
    # @user = User.find(order.user_id)
    order.cancel
    order.save
    redirect_to admin_user_path(@user)
    flash[:notice] = "Order #{order.id} has been cancelled."
  end

end
