class AddEnvironmentToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :environment, :string
    add_index :customers, :environment
  end
end
