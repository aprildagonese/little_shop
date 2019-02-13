class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart
  helper_method :current_user

  #Unhighlight if needed in view
  #helper_method :current_admin?
  #helper_method :current_merchant?
  #helper_method :current_registered?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end

  def current_registered?
    current_user && current_user.registered?
  end

  def require_admin
    render file: "/public/404" unless current_admin?
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def require_current_user
    unless current_registered?
      render file: "/public/404", status: :not_found
    end
  end

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

end
