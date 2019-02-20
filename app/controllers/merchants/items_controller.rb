class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to dashboard_items_path
    else
      flash[:error] = "Your item has been entered incorrectly."
      redirect_to dashboard_item_edit_path(@item)
    end
  end

  private
  def item_params
    params.require(:item).permit(:item_id, :title, :description, :image_url, :price, :quantity)
  end

end
