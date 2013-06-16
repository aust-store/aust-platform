class SuperAdmin::ApplicationController < ActionController::Base
  protect_from_forgery
  layout "super_admin"

  before_filter :authenticate_super_admin!
end
