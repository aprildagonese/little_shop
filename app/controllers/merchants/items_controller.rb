class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
  end

  def edit
    binding.pry
    @item = Item.find_by(title: params[:title])
  end

  def update
    @item = Item.find(params[:id])
    new_params = item_params
    new_params[:image_url] = set_url(item_params[:image_url])
    if @item.update(new_params)
      redirect_to dashboard_items_path
    else
      flash[:error] = "Dish title is already taken."
      redirect_to dashboard_item_edit_path(@item)
    end
  end

  private
  def item_params
    params.require(:item).permit(:item_id, :title, :description, :image_url, :price, :quantity)
  end

end
