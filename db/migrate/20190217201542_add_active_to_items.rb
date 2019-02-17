class AddActiveToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :active, :boolean
  end
end
