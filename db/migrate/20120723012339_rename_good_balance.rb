class RenameGoodBalance < ActiveRecord::Migration
  def change
    rename_table :good_balances, :inventory_entries
  end
end
