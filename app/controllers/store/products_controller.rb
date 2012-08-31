class Store::ProductsController < Store::ApplicationController
  def show
    @product = Store::ItemsForSale.new(self).inventory_entry
  end
end
