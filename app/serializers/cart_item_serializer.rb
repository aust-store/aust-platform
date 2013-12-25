class CartItemSerializer < OrderItemSerializer
  attributes :inventory_entry_id, :price
  has_one :cart, key: :cart_id, root: :cart, embed_in_root: false
  has_one :inventory_item, key: :inventory_item_id, root: :inventory_item

  def filter(keys)
    keys.delete(:order)
    keys
  end
end
