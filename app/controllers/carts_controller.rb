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
    @items = []
    @cart.contents.keys.each do |item_id|
      @items << Item.find(item_id)
    end
    @items
    @view = "Cart"
  end

end
