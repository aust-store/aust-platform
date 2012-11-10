class AddMerchandisingToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :merchandising, :text
  end
end
