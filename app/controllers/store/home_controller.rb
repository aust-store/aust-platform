class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    @entries = Store::ItemsForSale.new(self).items_for_homepage
  end
end
