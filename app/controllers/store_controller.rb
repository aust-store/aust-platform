class StoreController < Store::ApplicationController
  def show
  end

  def index
    self.class.layout "stores_index"
    @companies = Company.all
  end
end
