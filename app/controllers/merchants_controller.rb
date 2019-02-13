class MerchantsController < ApplicationController

  def index
    @users = User.where(role: 1).where(activation_status: 0)
  end

  def show
  end

end
