class Admin::UsersController < Admin::BaseController

  def show
    @user = User.find(params[:id])
    if @user.merchant?
      redirect_to admin_merchant_path(@user)
    end
  end

  def index
    @users = User.where(role: 0).order(:name)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "An account already exists for that email address."
      redirect_to edit_admin_user_path(@user)
    end
  end

  def activation
    @user = User.find(params[:user_id])
    @user.change_status
    if @user.merchant?
      redirect_to admin_merchants_path
    elsif @user.registered?
      redirect_to admin_users_path
    end
    if @user.active?
      flash[:alert] = "#{@user.name} has been enabled."
    elsif @user.inactive?
      flash[:alert] = "#{@user.name} has been disabled."
    end
  end

  def upgrade
    @user = User.find(params[:user_id])
    @user.upgrade
    flash[:upgraded] = "User role has been upgraded to 'merchant'."
    redirect_to admin_merchant_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :street_address, :city, :state, :zip_code)
  end

end
