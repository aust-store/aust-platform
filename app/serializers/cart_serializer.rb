class CartSerializer < ActiveModel::Serializer
  attributes :id, :total
  has_many :items, key: :cart_item_ids, root: :cart_items
  has_one :customer, key: :customer_id, root: :customer

  def filter(keys)
    if object.customer.blank?
      keys.delete(:customer)
    end
    keys
  end
end
