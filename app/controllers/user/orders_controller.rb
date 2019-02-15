class User::OrdersController < ApplicationController
  before_action :require_current_user

  def index
    #Didn't actually need this yet for my story so commenting out.
    #Check for accuracy
    #@orders = Order.where(user_id: current_user)
  end

  def show
  end

end
