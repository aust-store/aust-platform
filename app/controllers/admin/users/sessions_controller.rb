class Admin::Users::SessionsController < Devise::SessionsController
  
  protected

  def after_sign_in_path_for(resource)
    admin_dashboard_url
  end  
end