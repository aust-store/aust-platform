class AddSlugToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :slug, :string
    add_index :inventory_items, :slug
  end
end
