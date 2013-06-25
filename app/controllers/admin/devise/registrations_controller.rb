class Admin::Devise::RegistrationsController < Devise::RegistrationsController
  layout "admin/sign_up"
  before_filter :set_user_as_founder, only: [:create]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  private

  def set_user_as_founder
    params[:admin_user][:role] = 'founder'
  end

  def after_sign_up_path_for(resource)
    admin_dashboard_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email,
               :name,
               :role,
               :password,
               :password_confirmation,
               company_attributes: [:name, :handle])
    end
  end
end
