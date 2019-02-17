class OrdersController < ApplicationController
  def show    
    @order = Order.find(params[:id])
  end

  def create
    cart = session[:cart]
    Order.generate_order(cart, current_user)
    session.delete(:cart)
    flash[:success] = "Thank you! Your order has been placed."
    redirect_to profile_orders_path(current_user)
  end
end
