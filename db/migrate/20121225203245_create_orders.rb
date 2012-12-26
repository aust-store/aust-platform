class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.integer :user_id
      t.integer :store_id

      t.timestamps
    end
    add_index :orders, :cart_id
    add_index :orders, :user_id
    add_index :orders, :store_id
  end
end
