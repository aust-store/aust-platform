class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    @companies = Company.all
  end
end
