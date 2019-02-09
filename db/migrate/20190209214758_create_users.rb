class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :email
      t.string :password
      t.integer :role
      t.string :activation_status

      t.timestamps
    end
  end
end
