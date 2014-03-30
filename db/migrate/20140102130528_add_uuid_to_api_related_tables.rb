class AddUuidToApiRelatedTables < ActiveRecord::Migration
  class InventoryItem < ActiveRecord::Base; end
  class Cart          < ActiveRecord::Base; end
  class Order         < ActiveRecord::Base; end
  class OrderItem     < ActiveRecord::Base; end
  class Customer      < ActiveRecord::Base; end

  def up
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

    models.each { |m| m.find_each { |e| e.update_attribute(:updated_at, Time.now) } }
  end

  def down
    remove_column :carts, :uuid, :uuid
    remove_column :orders, :uuid, :uuid
    remove_column :order_items, :uuid, :uuid
    remove_column :customers, :uuid, :uuid
    remove_column :inventory_items, :uuid, :uuid
  end

  private

  def models
    [InventoryItem, Cart, Order, OrderItem, Customer]
  end
end
