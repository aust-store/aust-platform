class AddFtsIndexToInventoryItemsName < ActiveRecord::Migration
  def up
    execute "create index inventory_item_name on inventory_items using gin(to_tsvector('english', name))"
  end

  def down
    execute "drop index inventory_item_name"
  end
end
