class ChangeUsersRoleColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :role, :integer, default: 0
  end
end
