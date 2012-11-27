class CreateOrderShippings < ActiveRecord::Migration
  def change
    create_table :order_shippings do |t|
      t.references :cart
      t.references :order
      t.decimal :price
      t.integer :delivery_days
      t.text :delivery_type
      t.text :service_type

      t.timestamps
    end
    add_index :order_shippings, :cart_id
    add_index :order_shippings, :order_id
  end
end
