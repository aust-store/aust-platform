class AddImageToGood < ActiveRecord::Migration
  def change
    add_column :goods, :image, :string

  end
end
