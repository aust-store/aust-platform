class AddCoverToGoodImages < ActiveRecord::Migration
  def change
    add_column :good_images, :cover, :boolean, default: false
    add_index :good_images, :cover
  end
end
