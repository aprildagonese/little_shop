class ItemsController < ApplicationController

  def new
    @item = Item.new
  end

  def create
    @user = current_user
    @item = @user.items.new(item_params)
    @item.set_image
    @item.active = true

    if @item.save
      redirect_to dashboard_items_path
      flash[:alert] = "'#{@item.title}' has been saved and is available for sale."
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def index
    @items = Item.where(active: true)
    @top_items = Item.most_popular.limit(5)
    @bottom_items = Item.least_popular.limit(5)
  end

  def destroy
    item = Item.find(params[:id])
    item.delete
    redirect_to dashboard_items_path
    flash[:alert] = "#{item.title} has been deleted."
  end

  def enable
    @item = Item.find(params[:id])
    @item.change_status
    # if @item.merchant?
    #   redirect_to admin_merchants_path
    # elsif @item.registered?
    #   redirect_to admin_users_path
    # end
    redirect_to dashboard_items_path
    if @item.active
      flash[:alert] = "#{@item.title} has been enabled and is now available for sale."
    else
      flash[:alert] = "#{@item.title} has been disabled and is no longer for sale."
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :image_url, :price, :quantity)
  end

end
