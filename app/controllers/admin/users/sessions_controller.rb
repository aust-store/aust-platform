class Admin::Users::SessionsController < Devise::SessionsController
  layout "admin/sign_in"
  
  protected

  def after_sign_in_path_for(resource)
    admin_dashboard_url
  end  
end
