class Store::CartItemsController < Store::ApplicationController
  def create
    entry = Store::ItemsForSale.new(self).item_for_cart
    cart.add_item(entry)
    redirect_to store_cart_path(@company)
  end
end
