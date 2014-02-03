class AddReferenceNumberToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :reference_number, :string
    add_index :inventory_items, :reference_number
  end
end
