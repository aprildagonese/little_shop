class CartsController < ApplicationController
  before_action :require_cart_access

  def create
    item = Item.find(params[:item_id])
    @cart.add_item(item.id)
    session[:cart] = @cart.contents
    flash[:success] = "1 #{item.title} has been added to your cart."
    redirect_to items_path
  end

  def show
    #
    #@items = session[:cart]
    # @view = "Cart"
  end

end
