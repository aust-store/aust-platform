class Admin::ApplicationController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = "Acesso negado!"
    redirect_to admin_users_url, :alert => exception.message
  end

  before_filter :mobile_layout

  layout :define_layout
  before_filter :authenticate_admin_user!
  before_filter :navigation_namespace
  before_filter :current_company

  def current_user
    current_admin_user
  end

  def current_company
    @current_company = current_user.company
  end

  def currency
    current_company.currency
  end

  private

  def define_layout
    request.xhr? ? false : "admin"
  end

  def navigation_namespace
    @nav_namespace = case request.url
    when /admin\/inventory/  ; "inventory"
    when /admin\/statistics/ ; "statistics"
    when /admin\/users/      ; "users"
    when /admin\/store/      ; "store"
    when /admin\/settings/   ; "settings"
    when /admin\/taxonomies/ ; "taxonomies"
    when /admin\/order/      ; "orders"
    else nil
    end
  end

  def mobile_layout
    if RouterConstraints::Iphone.new.matches?(request) && !request.xhr?
      redirect_to mobile_admin_root_url
    end
  end
end
