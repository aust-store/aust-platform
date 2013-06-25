class SuperAdmin::SessionsController < Devise::SessionsController
  layout "super_admin/sign_in"

  def after_sign_in_path_for(resource)
    super_admin_root_url
  end
end
