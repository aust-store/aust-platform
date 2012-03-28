class Admin::ApplicationController < ActionController::Base
  protect_from_forgery

  layout :define_layout
  before_filter :authenticate_admin_user!
  before_filter :navigation_namespace

  private

  def define_layout
    request.xhr? ? false : "admin"
  end

  def current_user
    current_admin_user
  end

  def navigation_namespace
    @nav_namespace = case request.url
    when /inventory/ ; "inventory"
    when /customers/ ; "customers"
    when /store/     ; "store"
    else nil
    end
  end
end
