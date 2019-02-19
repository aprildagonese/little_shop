class RemoveStatusFromOrderItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :status
  end
end
