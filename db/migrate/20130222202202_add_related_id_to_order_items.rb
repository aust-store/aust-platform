class AddRelatedIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :related_id, :integer
    add_index  :order_items, :related_id
  end
end
