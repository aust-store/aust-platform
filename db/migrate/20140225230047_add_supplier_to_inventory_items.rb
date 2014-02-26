class AddSupplierToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :supplier_id, :integer
    add_index :inventory_items, :supplier_id
  end
end
