class RemoveStoreIdFromInventoryEntries < ActiveRecord::Migration
  def up
    remove_column :inventory_entries, :store_id
  end

  def down
    add_column :inventory_entries, :store_id, :integer
    add_index :inventory_entries, :store_id
  end
end
