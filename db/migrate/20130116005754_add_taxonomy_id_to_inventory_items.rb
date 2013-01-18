class AddTaxonomyIdToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :taxonomy_id, :integer
    add_index :inventory_items, :taxonomy_id
  end
end
