class AddEnvironmentToCart < ActiveRecord::Migration
  def change
    add_column :carts, :environment, :string
    add_index :carts, :environment
  end
end
