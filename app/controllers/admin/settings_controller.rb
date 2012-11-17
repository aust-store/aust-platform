class Admin::SettingsController < Admin::ApplicationController
  before_filter :authenticate_admin_user!

  def show
    @settings = CompanySetting.find_or_create_by_company_id(current_company.id)
  end

  def update
    @settings = current_company.settings
    if @settings.update_attributes(params[:company_setting])
      render json: @settings
    else
      render json: { errors: @settings.errors.full_messages }, status: 422
    end
  end
end
