class Store::CartItemsController < Store::ApplicationController
  skip_before_filter :load_taxonomies

  def create
    entry = Store::ItemsForSale.new(self).item_for_cart
    cart.add_item(entry)
    redirect_to cart_path
  end

  def destroy
    cart.remove_item(params[:id])
    redirect_to cart_path
  end
end
