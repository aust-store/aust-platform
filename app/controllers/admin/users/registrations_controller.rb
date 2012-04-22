class Admin::Users::RegistrationsController < Devise::RegistrationsController
  layout "admin/sign_up"

  def after_sign_up_path_for(resource)
    admin_dashboard_url
  end  
end
