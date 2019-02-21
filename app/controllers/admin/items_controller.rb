class Admin::ItemsController < Admin::BaseController

  def index
    #@items = Item.where(user: params[:user_id])
    @merchant = User.find(params[:user_id])
    @items = @merchant.items
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    new_params = item_params
    new_params[:image_url] = set_url(item_params[:image_url])
    if @item.update(new_params)
      item = Item.find(params[:id])
      id = item.user.id
      redirect_to admin_items_path(user_id: id)
      flash[:success] = "'#{@item.title}' has been updated."
    else
      flash[:error] = "Dish title is already taken."
      redirect_to edit_admin_item_path(@item)
    end
  end

  private
  def item_params
    params.require(:item).permit(:item_id, :title, :description, :image_url, :price, :quantity)
  end

end
