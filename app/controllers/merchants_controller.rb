class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    if current_user && current_user.admin?
      @users = User.where(role: 1).order(:name)
    else
      @users = User.where(role: 1).where(activation_status: 0)
    end
    @best_revenue_merchants = User.highest_revenues
    @fastest_merchants = User.fastest_fulfillments
    @slowest_merchants = User.slowest_fulfillments
  end

  def show
    @user = current_user
    @orders = Order.find_orders(@user)
    @top_five = Item.top_items_sold(@user).limit(5)
  end

  def update
    @user = User.find(params[:id])
    @user.change_status
    redirect_to admin_merchants_path
  end

end
