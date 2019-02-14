class ItemsController < ApplicationController
  def index
    @items = Item.all.where(activation_status: "active")
  end

  def show
    @item = Item.find(params[:id])
  end

end
