class CreatePriceTables < ActiveRecord::Migration
  def change
    create_table :inventory_item_prices do |t|
      t.integer :inventory_item_id
      t.decimal :value, precision: 8, scale: 2

      t.timestamps
    end
    add_index :inventory_item_prices, :inventory_item_id
  end
end
