class StoreController < Store::ApplicationController
  layout :set_layout

  def show
    @company = Company.where(handle: params[:id]).first
  end

  def index
    @companies = Company.all
  end

  private

  def set_layout
    case params[:action]
    when "index"; "stores_index"
    else "store"
    end
  end
end
