class Admin::ApplicationController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = "Acesso negado!"
    redirect_to admin_users_url, :alert => exception.message
  end

  before_filter :sign_out_if_incorrect_company
  before_filter :mobile_layout

  layout :define_layout
  before_filter :authenticate_admin_user!
  before_filter :navigation_namespace
  before_filter :current_company

  def current_user
    current_admin_user
  end

  # FIXME -- this loads the user company, not the subdomain company
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
    Rails.logger.info request.url
    @nav_namespace = case request.url
    when /admin\/inventory/  ; "inventory"
    when /admin\/statistics/ ; "statistics"
    when /admin\/users/      ; "users"
    when /admin\/(marketing|pages|banner|store_theme)/ ; "marketing"
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

  def sign_out_if_incorrect_company
    return unless current_user.present?

    if current_company_by_subdomain != current_user.company
      Rails.logger.info "Current user's company not the same as subdomain's."
      Rails.logger.info "Signing out automatically..."
      sign_out current_user
    end
  end
end
