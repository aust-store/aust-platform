class Store::CategoriesController < Store::ApplicationController
  def show
    @current_category = current_taxonomy
    @category = current_store.taxonomies.friendly.find(@current_category)

    items = Store::ItemsForWebsiteSale.new(self).items_for_category
    @items = Store::InventoryItemDecorator.decorate_collection(items)
  end

  def current_taxonomy
    params[:id]
  end
end
