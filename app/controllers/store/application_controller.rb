class Store::ApplicationController < ApplicationController
  layout "store"

  include ControllersExtensions::CartInstantiation
  include ControllersExtensions::Store::ViewObjects

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::LoadingGlobalInformations

  before_filter :load_application_wide_ad_banners

  private

  def load_application_wide_ad_banners
    @banners = {
      all_pages_right: Array(current_store.banners.all_pages_right)
    }
  end
end
