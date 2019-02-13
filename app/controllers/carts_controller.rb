class CartsController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    flash[:notice] = "1 #{item.name} has been added to your cart."
    redirect_to visitor_items_path
  end

  def show
    #@items =
    #@view = "Cart"
  end

end
