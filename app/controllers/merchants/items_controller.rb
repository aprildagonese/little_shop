class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
  end

end
