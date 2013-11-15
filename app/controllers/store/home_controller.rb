class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    products
    @banners[:main_page_central_rotative] = current_store.banners.main_page_central_rotative
  end
end
