class Admin::Devise::SessionsController < Devise::SessionsController
  layout "admin/sign_in"

  before_filter :load_store_information

  private

  def current_subdomain
    if request.subdomain.present?
      Array(request.subdomain).last
    end
  end

  def load_store_information
    if current_subdomain.present?
      Rails.logger.info "Visiting #{current_subdomain} store."
      @company ||= Company.find_by_handle(current_subdomain)
    end
  end

  def after_sign_in_path_for(resource)
    admin_dashboard_url
  end
end
