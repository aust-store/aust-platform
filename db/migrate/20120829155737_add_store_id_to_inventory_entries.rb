class AddStoreIdToInventoryEntries < ActiveRecord::Migration
  def change
    add_column :inventory_entries, :store_id, :integer
    add_index :inventory_entries, :store_id
  end
end
