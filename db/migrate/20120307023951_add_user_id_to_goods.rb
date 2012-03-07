class AddUserIdToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :admin_user_id, :integer
  end
end
