class AddFulfillmentStatusOnOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :fulfillment_status, :integer, default: 0
  end
end
