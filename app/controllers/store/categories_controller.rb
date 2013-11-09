class Store::CategoriesController < Store::ApplicationController
  def show
    @current_category = params[:id]
    @category = current_store.taxonomies.friendly.find(@current_category)

    items = Store::ItemsForSale.new(self).items_for_category
    @items = Store::InventoryItemDecorator.decorate_collection(items)
  end
end
