class RemoveInventoryItemProperties < ActiveRecord::Migration
  def up
    drop_table :inventory_item_properties
  end

  def down
  end
end
