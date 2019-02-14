class MerchantsController < ApplicationController
  before_action :require_merchant, only: :show

  def index
    @users = User.where(role: 1).where(activation_status: 0).order(:name)
  end

  def show
  end

  def update
    @user = User.find(params[:id])
    @user.change_status
    redirect_to admin_merchants_path
  end

end
