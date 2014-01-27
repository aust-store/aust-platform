class AddBarcodeToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :barcode, :string
    add_index :inventory_items, :barcode
  end
end
