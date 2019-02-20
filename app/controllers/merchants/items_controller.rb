class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
  end

  def edit
    binding.pry
    @item = Item.find(params[:item_id])
  end

end
