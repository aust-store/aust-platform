class AddCompanyToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :company_id, :integer
    
    add_index :admin_users, :company_id
  end
end
