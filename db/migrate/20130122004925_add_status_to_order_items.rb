class AddStatusToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :status, :string
    add_index :order_items, :status
  end
end
