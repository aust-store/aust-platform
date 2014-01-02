class CartItemSerializer < OrderItemSerializer
  attributes :id, :inventory_entry_id, :price

  has_one :cart, key: :cart_id, root: :cart, embed_in_root: false, embed_key: :uuid
  has_one :inventory_item, key: :inventory_item_id, root: :inventory_item, embed_key: :uuid

  def id
    object.uuid
  end

  def filter(keys)
    keys.delete(:order)
    keys
  end
end
