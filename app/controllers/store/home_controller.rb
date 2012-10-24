class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    items = Store::ItemsForSale.new(self).items_for_homepage
    @items = Store::InventoryItemDecorator.decorate(items)
  end
end
