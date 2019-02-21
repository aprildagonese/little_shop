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
    @items = Item.where(id: @cart.contents.keys)
    @view = "Cart"
  end


  def update
    item = Item.find(params[:item_id])
    if params[:qty].to_i <= item.quantity
      @cart.contents[params[:item_id]] = params[:qty].to_i
    else
      flash[:insufficient] = "Not Enough Items In Stock"
    end
    if @cart.contents[params[:item_id]] == 0
      @cart.contents.delete(params[:item_id])
    end
    redirect_to cart_path
  end

  def delete_item
    @cart.contents.delete(params[:item])
    redirect_to cart_path
  end

  def destroy
    session.delete(:cart)
    redirect_to cart_path
  end

end
