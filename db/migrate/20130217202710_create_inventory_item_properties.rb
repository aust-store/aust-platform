class CreateInventoryItemProperties < ActiveRecord::Migration
  def change
    create_table :inventory_item_properties do |t|
      t.integer :inventory_item_id
      t.hstore :properties

      t.timestamps
    end
    add_index :inventory_item_properties, :inventory_item_id
    execute "CREATE INDEX item_properties ON inventory_item_properties USING GIN(properties)"
  end
end
