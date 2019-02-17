class ItemsController < ApplicationController
  def index
    @items = Item.where(active: true)
    @top_items = Item.most_popular.limit(5)
    @bottom_items = Item.least_popular.limit(5)
  end

  def show
    @item = Item.find(params[:id])
  end

end
