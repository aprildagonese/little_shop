require 'uri'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart
  helper_method :current_user

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
    render file: "/public/404" unless current_admin? || current_merchant?
  end

  def require_cart_access
    render file: "/public/404" unless current_user.nil? || current_user.registered?
  end

  def require_current_user
    unless current_registered?
      render file: "/public/404", status: :not_found
    end
  end

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def set_url(url)
    default_url = "https://2static.fjcdn.com/pictures/Generic+food+image+if+anyones+old+or+watched+repo+man_47b808_5979251.jpg"
    if url =~ URI::regexp
      url
    else
      default_url
    end
  end

end
