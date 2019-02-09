class Registered::ItemsController < ApplicationController
  before_action :require_registered

  def index
  end

  private
  def require_registered
    render file: "/public/404" unless current_registered?
  end
end
