class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :price,
             :inventory_item_id, :inventory_entry_id
end
