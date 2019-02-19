class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    if current_user && current_user.admin?
      #move order by name to a model
      @users = User.where(role: 1).order(:name)
    else
      @users = User.where(role: 1).where(activation_status: 0).order(:name)
    end
  end

  def show
    @user = current_user
    @orders = Order.find_orders(@user)
    @top_five = Item.top_items_sold(@user).limit(5)
    @total_sold = Item.total_sold_quantity(@user)
    @percent_sold = Item.percent_sold(@user)
    # @most_orders = User.user_by_most_orders(@user)
    # @order_count = @most_orders.orders.count
  end

  def update
    @user = User.find(params[:id])
    @user.change_status
    redirect_to admin_merchants_path
    flash[:success] = "#{@user.name} has been disabled."
  end

end
