class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    @goods = @company.list_goods
  end
end
