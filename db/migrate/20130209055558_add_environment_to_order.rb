class AddEnvironmentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :environment, :string
    add_index :orders, :environment
  end
end
