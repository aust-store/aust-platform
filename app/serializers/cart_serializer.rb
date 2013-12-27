class CartSerializer < ActiveModel::Serializer
  attributes :id, :total
  has_many :items, key: :cart_item_ids, root: :cart_items
  has_one :customer, key: :customer_id, root: :customer
end
