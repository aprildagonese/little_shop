class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    if current_user && current_user.admin?
      @users = User.where(role: 1)
    else
      @users = User.where(role: 1).where(activation_status: 0)
    end
    @best_revenue_merchants = User.highest_revenues
    @fastest_merchants = User.fastest_fulfillments
    @slowest_merchants = User.slowest_fulfillments
    @highest_order_states = User.most_orders_by_state
    @highest_order_cities = User.most_orders_by_city
    @biggest_orders = Order.largest_orders
  end

  def show
    @user = current_user
    @orders = Order.find_orders(@user)
    @top_five = Item.top_items_sold(@user).limit(5)
    @top_three_states = @user.top_states(3)
    @top_three_cities = @user.top_city_states(3)
    @top_three_patrons = @user.top_spending_patrons(3)
    @top_items_patrons = @user.most_items_patrons(1)
    @top_orders_patrons = @user.most_orders_patrons(1)
    @total_sold = Item.total_sold_quantity(@user)
    @percent_sold = Item.percent_sold(@user)
  end

  def update
    @user = User.find(params[:id])
    @user.change_status
    redirect_to admin_merchants_path
    flash[:success] = "#{@user.name} has been disabled."
  end

end
