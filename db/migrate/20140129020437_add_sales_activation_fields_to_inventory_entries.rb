class AddSalesActivationFieldsToInventoryEntries < ActiveRecord::Migration
  def change
    add_column :inventory_entries, :point_of_sale, :boolean
    add_index :inventory_entries, :point_of_sale
    add_column :inventory_entries, :website_sale, :boolean, default: true
  end
end
