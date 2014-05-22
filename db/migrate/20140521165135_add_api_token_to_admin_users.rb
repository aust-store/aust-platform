class AddApiTokenToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :api_token, :string
    add_index :admin_users, :api_token
  end
end
