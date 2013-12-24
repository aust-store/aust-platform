class CartItemSerializer < OrderItemSerializer
  attributes :cart

  def cart
    object.cart_id
  end
end
