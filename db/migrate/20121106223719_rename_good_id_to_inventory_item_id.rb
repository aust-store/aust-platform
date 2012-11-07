class RenameGoodIdToInventoryItemId < ActiveRecord::Migration
  def change
    rename_column :inventory_entries, :good_id, :inventory_item_id

    # images
    rename_table :good_images, :inventory_item_images
    rename_column :inventory_item_images, :good_id, :inventory_item_id
  end
end
