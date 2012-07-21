class Store::HomeController < Store::ApplicationController
  layout "store"

  def index
    @company = Company.where(handle: params[:store_id]).first
    @goods = @company.list_goods
  end
end
