class AddImageToGoodImage < ActiveRecord::Migration
  def change
    add_column :good_images, :image, :string

  end
end
