class Admin::MerchantsController < Admin::BaseController
  def index
    @users = User.where(role: 1).order(:name)
  end

  def show
    @user = User.find(params[:id])
    if @user.role != "merchant"
      redirect_to admin_user_path(@user)
    end
  end

  def update
  end

  def downgrade
    binding.pry
    @user = User.find(params[:id])
    @user.downgrade
    flash[:downgraded] = "Merchant has been downgraded to a user"
    redirect_to admin_user_path(@user)
  end
end
