class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    items = Store::ItemsForSale.new(self).items_for_main_page
    @items = Store::InventoryItemDecorator.decorate_collection(items)
    @banners[:main_page_central_rotative] = current_store.banners.main_page_central_rotative
  end
end
