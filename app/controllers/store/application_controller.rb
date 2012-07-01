class Store::ApplicationController < ActionController::Base
  protect_from_forgery
  layout "store"
  before_filter :load_store_information

private

  def load_store_information
    @company = Company.where(handle: params[:store_id]).first
  end
end
