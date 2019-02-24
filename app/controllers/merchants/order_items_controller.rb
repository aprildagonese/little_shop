class Merchants::OrderItemsController < Merchants::BaseController

  def update
    order_item = OrderItem.find(params[:slug])
    order_item.fulfill_order_item
    order_item.order.check_status
    flash[:success] = "Your item has been fulfilled."
    if current_user.merchant?
      redirect_to dashboard_order_path(order_item.order)
    elsif current_user.admin?
      @order = Order.find(params[:order])
      @merchant = User.find(params[:merchant])
      redirect_to admin_merchant_order_path(order: @order, merchant: @merchant)
    end
  end
end
