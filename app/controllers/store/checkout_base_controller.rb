class Store::CheckoutBaseController < Store::ApplicationController
  before_filter :authenticate_user!
end
