class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    @users = User.where(role: 1).where(activation_status: 0)
  end

  def show
  end

end
