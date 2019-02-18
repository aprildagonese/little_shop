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
    binding.pry
    redirect_to admin_orders_path
  end

end
