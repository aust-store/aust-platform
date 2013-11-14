class Store::ApplicationController < ApplicationController
  layout "store"

  include ControllersExtensions::CartInstantiation
  include ControllersExtensions::Store::ViewObjects

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::Resources

  def render(*args)
    # TODO - cache mustache layouts somehow. Average view load time in
    # development is around 45ms.
    super
  end
end
