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
    # @items = []
    # @cart.contents.keys.each do |item_id|
    #   @items << Item.find(item_id)
    # end
    @items = Item.where(id: @cart.contents.keys)
    @view = "Cart"
  end

  def update
    @cart.contents[params[:item_id]] = params[:qty].to_i
    if @cart.contents[params[:item_id]] == 0
      @cart.contents.delete(params[:item_id])
    end
    redirect_to cart_path
  end

  def destroy
    @cart.contents.delete(params[:item])
    redirect_to cart_path
  end

end
