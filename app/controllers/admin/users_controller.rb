class Admin::UsersController < Admin::BaseController

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  private
  #
  # def user_params
  #   params.require(:user).permit(:name, :email, :password)
  # end

end
