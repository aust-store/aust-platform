class MobileAdmin::Devise::SessionsController < Devise::SessionsController
  layout "mobile_admin/sign_in"

  def after_sign_in_path_for(resource)
    admin_root_url
  end
end
