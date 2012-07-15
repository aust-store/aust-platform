class HomeController < Store::ApplicationController
  layout "stores_index"

  def index
    @companies = Company.all
  end
end
