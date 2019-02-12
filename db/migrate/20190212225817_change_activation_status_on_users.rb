class ChangeActivationStatusOnUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :activation_status
    add_column :users, :activation_status, :integer, default: 0
  end
end
