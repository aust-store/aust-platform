class AddPriceToInventoryEntries < ActiveRecord::Migration
  def change
    add_column :inventory_entries, :price, :decimal, precision: 8, scale: 2
  end
end
