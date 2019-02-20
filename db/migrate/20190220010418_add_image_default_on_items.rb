class AddImageDefaultOnItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image_url, :text, default: "https://2static.fjcdn.com/pictures/Generic+food+image+if+anyones+old+or+watched+repo+man_47b808_5979251.jpg"
  end
end
