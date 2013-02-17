class AddIdentificationFieldsToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :size, :string
    add_column :inventory_items, :year, :integer
    add_column :inventory_items, :model, :text
    add_column :inventory_items, :manufacturer_id, :integer
    add_index :inventory_items, :manufacturer_id
  end
end
