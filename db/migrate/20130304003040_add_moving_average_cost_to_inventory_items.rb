class AddMovingAverageCostToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :moving_average_cost, :decimal, precision: 8, scale: 2
  end
end
