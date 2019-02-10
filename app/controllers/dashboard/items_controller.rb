class Dashboard::ItemsController < ApplicationController
  before_action :require_merchant

  def new
    @item = Item.new
  end

  def create
  end

  def index
    @items = Item.where(user: current_user)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

end
