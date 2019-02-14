class Admin::MerchantsController < Admin::BaseController
  def index
    @users = User.where(role: 1)
  end
end
