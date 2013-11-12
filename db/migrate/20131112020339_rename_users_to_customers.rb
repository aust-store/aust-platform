class RenameUsersToCustomers < ActiveRecord::Migration
  def change
    rename_table :users, :customers

    rename_column :carts,  :user_id, :customer_id
    rename_column :orders, :user_id, :customer_id
  end
end
