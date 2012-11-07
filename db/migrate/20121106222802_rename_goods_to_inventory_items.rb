class RenameGoodsToInventoryItems < ActiveRecord::Migration
  def change
    rename_table :goods, :inventory_items
  end
end
