class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :price, :inventory_entry_id
  has_one :order
  has_one :inventory_item
end
