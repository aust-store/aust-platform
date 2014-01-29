class Store::ProductsController < Store::ApplicationController
  def show
    product
  end

  def product
    entry = Store::ItemsForWebsiteSale.new(self).detailed_item_for_show_page(params[:id])
    @product ||= DecorationBuilder.inventory_items(entry)
  end
end
