class CreateGoodBalances < ActiveRecord::Migration
  def change
    create_table :good_balances do |t|
      t.references :good
      t.references :admin_user
      t.string :balance_type
      t.text :description
      t.decimal :quantity
      t.decimal :cost_per_unit
      t.decimal :moving_average_cost
      t.decimal :total_quantity
      t.decimal :total_cost

      t.timestamps
    end
    add_index :good_balances, :good_id
    add_index :good_balances, :admin_user_id
  end
end
