class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    entries = Store::ItemsForSale.new(self).items_for_main_page
    @items = Store::InventoryItemDecorator.decorate(entries)
  end
end