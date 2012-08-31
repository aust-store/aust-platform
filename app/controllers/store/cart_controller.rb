class Store::CartController < Store::ApplicationController
  layout "store"

  def show
    @cart_items = cart.items
  end
end
