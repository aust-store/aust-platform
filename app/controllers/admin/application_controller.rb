class Admin::ApplicationController < ActionController::Base
  protect_from_forgery

  layout :define_layout
  before_filter :authenticate_admin_user!

  def define_layout
    request.xhr? ? false : "admin"
  end
end
