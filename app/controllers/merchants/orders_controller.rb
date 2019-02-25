class Merchants::OrdersController < Merchants::BaseController

  def show
    if current_user.merchant?
      @order = Order.find(params[:slug])
      @order_items = @order.user_items(current_user)
    elsif current_user.admin?
      @order = Order.find(params[:order])
      @merchant = User.find(params[:merchant])
      @order_items = @order.user_items(@merchant)
    end
  end
end
