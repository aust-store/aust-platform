class Store::Devise::SessionsController < Devise::SessionsController
  layout "store"

  include ControllersExtensions::StoreApplication
end
