class SuperAdmin::ApplicationController < ApplicationController
  before_filter :authenticate_super_admin!

  layout "super_admin"
end
