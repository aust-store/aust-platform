class RemoveAverageCostFieldsFromInventoryEntry < ActiveRecord::Migration
  def up
    remove_column :inventory_entries, :total_quantity
    remove_column :inventory_entries, :total_cost
    remove_column :inventory_entries, :moving_average_cost
    remove_column :inventory_entries, :balance_type
  end

  def down
    add_column :inventory_entries, :total_quantity, :decimal
    add_column :inventory_entries, :total_cost, :decimal
    add_column :inventory_entries, :moving_average_cost, :decimal
    add_column :inventory_entries, :balance_type, :string
  end
end
