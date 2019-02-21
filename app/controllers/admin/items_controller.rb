class Admin::ItemsController < Admin::BaseController

  def index
    @items = Item.where(user: params[:user_id])
    @merchant = User.find(params[:user_id])
  end

end
