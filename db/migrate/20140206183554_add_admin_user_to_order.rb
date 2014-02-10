class AddAdminUserToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :admin_user, index: true
  end
end
