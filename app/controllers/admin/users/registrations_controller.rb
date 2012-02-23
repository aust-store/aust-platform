class Admin::Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    admin_dashboard_url
  end  
end