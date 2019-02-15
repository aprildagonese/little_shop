class UpdateActivationStatusOnOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :activation_status
    add_column :orders, :status, :integer, default: 0
  end
end
