class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :price, :inventory_entry_id
  has_one :order, embed_key: :uuid
  has_one :inventory_item, embed_key: :uuid

  def id
    object.uuid
  end
end
