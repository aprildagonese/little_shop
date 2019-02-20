class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
  end

  def edit
    @item = Item.find(params[:id])
  end

end
