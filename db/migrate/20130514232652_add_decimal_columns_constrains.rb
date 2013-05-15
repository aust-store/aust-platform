class AddDecimalColumnsConstrains < ActiveRecord::Migration
  def up
    change_column :account_receivables, :value, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :inventory_entries, :quantity, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :inventory_entries, :cost_per_unit, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :inventory_item_prices, :value, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :inventory_items, :moving_average_cost, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :order_items, :price, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :order_items, :quantity, :decimal, null: false, default: 0.0, precision: 10, scale: 2
    change_column :order_shippings, :price, :decimal, null: false, default: 0.0, precision: 10, scale: 2
  end

  def down
    change_column :account_receivables, :value, :decimal, null: true, default: nil
    change_column :inventory_entries, :quantity, :decimal, null: true, default: nil
    change_column :inventory_entries, :cost_per_unit, :decimal, null: true, default: nil
    change_column :inventory_item_prices, :value, :decimal, null: true, default: nil
    change_column :inventory_items, :moving_average_cost, :decimal, null: true, default: nil
    change_column :order_items, :price, :decimal, null: true, default: nil
    change_column :order_items, :quantity, :decimal, null: true, default: nil
    change_column :order_shippings, :price, :decimal, null: true, default: nil
  end
end
