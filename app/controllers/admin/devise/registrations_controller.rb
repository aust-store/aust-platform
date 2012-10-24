class Admin::Devise::RegistrationsController < Devise::RegistrationsController
  layout "admin/sign_up"
  before_filter :set_user_as_founder, only: [:create]

private

  def set_user_as_founder
    params[:admin_user][:role] = 'founder'
  end

  def after_sign_up_path_for(resource)
    admin_dashboard_url
  end
end