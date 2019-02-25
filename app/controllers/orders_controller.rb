class OrdersController < ApplicationController

  def create
    cart = session[:cart]
    Order.generate_order(cart, current_user)
    session.delete(:cart)
    flash[:success] = "Thank you! Your order has been placed."
    redirect_to profile_orders_path
  end
end
