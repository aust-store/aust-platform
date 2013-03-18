class AddAdminUserIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :admin_user_id, :integer
    add_index :pages, :admin_user_id
  end
end
