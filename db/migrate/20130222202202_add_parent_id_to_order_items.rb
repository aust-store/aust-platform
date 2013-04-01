class AddParentIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :parent_id, :integer
    add_index  :order_items, :parent_id
  end
end