class AddAdminUserToManufacturers < ActiveRecord::Migration
  def change
    add_column :manufacturers, :admin_user_id, :integer
    add_index :manufacturers, :admin_user_id
  end
end
