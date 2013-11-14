class Store::ProductsController < Store::ApplicationController
  def show
    product
  end

  def product
    entry = Store::ItemsForSale.new(self).detailed_item_for_show_page
    @product ||= DecorationBuilder.inventory_items(entry)
  end
end
