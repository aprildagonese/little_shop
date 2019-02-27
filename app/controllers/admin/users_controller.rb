class Admin::UsersController < Admin::BaseController

  def show
    @user = User.find_by(slug: params[:slug])
    if @user.merchant?
      redirect_to admin_merchant_path(@user.slug)
    end
  end

  def index
    @users = User.where(role: 0).order(:name)
  end

  def edit
    @user = User.find_by(slug: params[:slug])
  end

  def update
    @user = User.find_by(slug: params[:slug])
    if @user.update(user_params)
      @user.create_slug
      redirect_to admin_user_path(@user.slug)
    else
      flash[:error] = "That email has already been taken."
      redirect_to edit_admin_user_path(@user.slug)
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
      flash[:alert] = "#{@user.name} has been re-enabled."
    elsif @user.inactive?
      flash[:alert] = "#{@user.name} has been disabled."
    end
  end

  def upgrade
    @user = User.find_by(slug: params[:slug])
    @user.upgrade
    flash[:upgraded] = "User has been upgraded to a merchant"
    redirect_to admin_merchant_path(@user.slug)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :street_address, :city, :state, :zip_code)
  end

end
