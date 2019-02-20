class Admin::ItemsController < Admin::BaseController

  def index
    @items = Item.where(user: params[:user_id])
    @merchant = User.find(params[:user_id])
  end

  def edit
    #edit an item
  end

  def update
  end

  def destroy
  end

end
