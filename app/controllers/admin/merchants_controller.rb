class Admin::MerchantsController < Admin::BaseController

  def index
    @users = User.where(role: 1).order(:name)
  end

  def show
    @user = User.find(params[:id])
    if @user.registered?
      redirect_to admin_user_path(@user)
    end
  end

  def update
  end

  def downgrade
    @user = User.find(params[:user_id])
    @user.downgrade
    flash[:downgraded] = "Merchant role has been downgraded to 'user'."
    redirect_to admin_user_path(@user)
  end
end
