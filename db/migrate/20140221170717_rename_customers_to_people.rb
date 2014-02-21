class RenameCustomersToPeople < ActiveRecord::Migration
  def change
    rename_table :customers, :people
  end
end
