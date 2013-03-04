class RemovePriceFromInventoryEntries < ActiveRecord::Migration
  def up
    remove_column :inventory_entries, :price
  end

  def down
    add_column :inventory_entries, :price, :decimal, precision: 8, scale: 2
  end
end
