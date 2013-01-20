class Store::ApplicationController < ApplicationController
  before_filter :load_taxonomies
  layout "store"

  include ControllersExtensions::CartInstantiation

  def load_taxonomies
    @taxonomies = current_store.taxonomies.hash_tree_for_homepage
  end
end
