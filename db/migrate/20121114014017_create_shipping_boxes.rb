class CreateShippingBoxes < ActiveRecord::Migration
  def change
    create_table :shipping_boxes do |t|
      t.decimal :length, precision: 8, scale: 2
      t.decimal :width, precision: 8, scale: 2
      t.decimal :height, precision: 8, scale: 2
      t.decimal :weight, precision: 8, scale: 2
      t.integer :inventory_item_id

      t.timestamps
    end

    add_index :shipping_boxes, :inventory_item_id
  end
end
