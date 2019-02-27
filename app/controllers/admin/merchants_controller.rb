class Admin::MerchantsController < Admin::BaseController

  def index
    @users = User.where(role: 1).order(:name)
    
    @total_sales = User.total_sales_chart
    @best_revenue_merchants = User.highest_revenues
    @fastest_merchants = User.fastest_fulfillments
    @slowest_merchants = User.slowest_fulfillments
    @highest_order_states = User.most_orders_by_state
    @highest_order_cities = User.most_orders_by_city
    @biggest_orders = Order.largest_orders
  end

  def show
    @user = User.find_by(slug: params[:slug])
    if @user.registered?
      redirect_to admin_user_path(@user.slug)
    end

    @orders = Order.find_orders(@user)

    @yearly_revenue = @user.years_revenue
    @top_five = Item.top_items_sold(@user).limit(5)
    @top_three_states = @user.top_states(3)
    @top_three_cities = @user.top_city_states(3)
    @top_three_patrons = @user.top_spending_patrons(3)
    @top_items_patrons = @user.most_items_patrons(1)
    @top_orders_patrons = @user.most_orders_patrons(1)
    @total_sold = Item.total_sold_quantity(@user)
    @percent_sold = Item.percent_sold(@user)
  end

  def downgrade
    @user = User.find_by(slug: params[:slug])
    @user.downgrade
    flash[:downgraded] = "Merchant has been downgraded to a user"
    redirect_to admin_user_path(@user.slug)
  end
end
