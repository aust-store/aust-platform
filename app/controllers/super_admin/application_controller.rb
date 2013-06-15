class SuperAdmin::ApplicationController < ApplicationController
  #before_filter :authenticate_user_admin!

  layout "super_admin"
end
