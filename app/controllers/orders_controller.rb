class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def create
    cart = session[:cart]
    Order.generate_order(cart)
    redirect_to profile_path(current_user)
  end
end
