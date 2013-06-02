class AddDimensionsToOrderShippings < ActiveRecord::Migration
  def change
    add_column :order_shippings, :description, :text
    add_column :order_shippings, :package_width,  :integer
    add_column :order_shippings, :package_height, :integer
    add_column :order_shippings, :package_length, :integer
    add_column :order_shippings, :package_weight, :decimal, precision: 8, scale: 2
  end
end
