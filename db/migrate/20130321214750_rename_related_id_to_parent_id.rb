class RenameRelatedIdToParentId < ActiveRecord::Migration
  def change
    rename_column :order_items, :related_id, :parent_id
  end
end
