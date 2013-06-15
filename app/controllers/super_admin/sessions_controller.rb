class SuperAdmin::SessionsController < Devise::SessionsController
  layout "admin/sign_in"

  def after_sign_in_path_for(resource)
    super_admin_dashboard_url
  end
end
