class SuperAdmin::ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_super_admin_user!

  layout "super_admin"
end
