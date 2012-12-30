class Store::ApplicationController < ApplicationController
  layout "store"

  include ControllersExtensions::CartInstantiation
end
