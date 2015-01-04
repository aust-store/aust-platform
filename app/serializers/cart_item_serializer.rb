class CartItemSerializer < OrderItemSerializer
  attributes :id, :name, :quantity, :price, :price_for_installments

  belongs_to :cart, embed: :ids
  belongs_to :inventory_item, embed: :ids
  belongs_to :inventory_entry, embed: :ids

  def id
    object.uuid
  end

  def filter(keys)
    keys.delete(:order)
    keys
  end
end
