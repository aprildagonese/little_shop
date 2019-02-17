class RemoveActivationStatusFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :activation_status
  end
end
