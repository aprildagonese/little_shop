class ItemsController < ApplicationController

  def new
    @item = Item.new
    @merchant = params[:user]
  end

  def create
    if current_user.admin?
      @user = User.find(params[:user])
    else
      @user = current_user
    end
    @item = @user.items.new(item_params)
    @item.image_url = set_url(params[:image_url])
    @item.active = true
    @item.create_slug

    if @item.save
      redirect_to dashboard_items_path if current_user.merchant?
      redirect_to admin_items_path(slug: @user.slug) if current_user.admin?
      flash[:alert] = "'#{@item.title}' has been saved and is available for sale."
    else
      render :new
    end
  end

  def show
    @item = Item.find_by(slug: params[:slug])
  end

  def index
    @items = Item.where(active: true)
    @top_items = Item.most_popular.limit(5)
    @bottom_items = Item.least_popular.limit(5)
  end

  def destroy
    item = Item.find_by(slug: params[:slug])
    item.delete
    redirect_to dashboard_items_path if current_user.merchant?
    redirect_to admin_items_path(slug: item.user.slug) if current_user.admin?
    flash[:alert] = "#{item.title} has been deleted."
  end

  def enable
    @item = Item.find_by(slug: params[:slug])
    @item.change_status
    redirect_to dashboard_items_path if current_user.merchant?
    redirect_to admin_items_path(slug: @item.user.slug) if current_user.admin?
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
