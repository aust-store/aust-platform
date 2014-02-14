class AddCustomFieldsToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :custom_fields, :hstore
    add_index  :inventory_items, :custom_fields, using: :gin
  end
end
