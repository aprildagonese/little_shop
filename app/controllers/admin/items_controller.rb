class Admin::ItemsController < ApplicationController
  before_action :require_admin

  def new
    #add new item to a merchant
  end

  def create
    #create item with merchant
    #redirect_to admin_merchant_items_path(@merchant)
  end

  def index
  end

  def edit
    #edit an item
  end

  def update
  end

  def destroy
  end

  private

end
