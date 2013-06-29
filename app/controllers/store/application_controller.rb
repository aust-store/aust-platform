class Store::ApplicationController < ApplicationController
  layout "store"

  include ControllersExtensions::CartInstantiation
  include ControllersExtensions::Store::ViewObjects

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::LoadingGlobalInformations
end
