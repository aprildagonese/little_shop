class Merchants::OrdersController < Merchants::BaseController

  def show
    @order = Order.find(params[:id])

    @order_items = @order.user_items(current_user)
  end
end
