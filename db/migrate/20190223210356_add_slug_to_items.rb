class AddSlugToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :slug, :string
  end
end
