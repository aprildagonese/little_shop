class Admin::UsersController < Admin::BaseController

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def edit
    @admin = current_user
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "That email has already been taken"
      redirect_to edit_admin_user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :street_address, :city, :state, :zip_code)
  end

end
