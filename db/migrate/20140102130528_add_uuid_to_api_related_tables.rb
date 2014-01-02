class AddUuidToApiRelatedTables < ActiveRecord::Migration
  def change
    add_column :carts, :uuid, :uuid
    add_column :orders, :uuid, :uuid
    add_column :order_items, :uuid, :uuid
    add_column :customers, :uuid, :uuid
    add_column :inventory_items, :uuid, :uuid

    add_index :carts, :uuid
    add_index :orders, :uuid
    add_index :order_items, :uuid
    add_index :customers, :uuid
    add_index :inventory_items, :uuid
  end
end
