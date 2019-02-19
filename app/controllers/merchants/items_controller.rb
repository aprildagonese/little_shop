class Merchants::ItemsController < Merchants::BaseController

  def index
    @items = Item.where(user: current_user)
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

end
