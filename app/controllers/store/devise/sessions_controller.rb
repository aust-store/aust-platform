class Store::Devise::SessionsController < Devise::SessionsController
  layout "store"

  include ControllersExtensions::CartInstantiation

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::LoadingGlobalInformations
end
