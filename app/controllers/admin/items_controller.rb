class Admin::ItemsController < Admin::BaseController

  def index
    @merchant = User.find_by(slug: params[:slug])
    @items = @merchant.items
  end

  def edit
    @item = Item.find_by(slug: params[:slug])
    @merchant = @item.user
  end

  def update
    @item = Item.find_by(slug: params[:slug])
    new_params = item_params
    new_params[:image_url] = set_url(item_params[:image_url])
    if @item.update(new_params)
      item = Item.find_by(slug: params[:slug])
      id = item.user.id
      redirect_to admin_items_path(slug: @item.user.slug)
      flash[:success] = "'#{@item.title}' has been updated."
    else
      flash[:error] = "Dish title is already taken."
      redirect_to edit_admin_item_path(@item)
    end
  end

  private
  def item_params
    params.require(:item).permit(:item_id, :slug, :title, :description, :image_url, :price, :quantity)
  end

end
