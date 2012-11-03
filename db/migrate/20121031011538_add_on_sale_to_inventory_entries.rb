class AddOnSaleToInventoryEntries < ActiveRecord::Migration
  def change
    add_column :inventory_entries, :on_sale, :boolean, default: true
    add_index :inventory_entries, :on_sale
  end
end
