class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :inventory_item
      t.decimal :price, precision: 8, scale: 2
      t.decimal :quantity, precision: 8, scale: 2
      t.references :inventory_entry
      t.references :inventory_entry

      t.references :cart
      t.references :order

      t.timestamps
    end

    add_index :order_items, :inventory_item_id
    add_index :order_items, :inventory_entry_id
    add_index :order_items, :cart_id
    add_index :order_items, :order_id
  end
end
