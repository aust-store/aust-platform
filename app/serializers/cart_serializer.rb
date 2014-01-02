class CartSerializer < ActiveModel::Serializer
  attributes :id, :total

  has_many :items, key: :cart_item_ids, root: :cart_items, embed_key: :uuid
  has_one :customer, key: :customer_id, root: :customer, embed_key: :uuid

  def id
    object.uuid
  end

  def filter(keys)
    if object.customer.blank?
      keys.delete(:customer)
    end
    keys
  end
end
