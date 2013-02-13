class Admin::SettingsController < Admin::ApplicationController
  def show
    @settings = CompanySetting.find_or_create_by_company_id(current_company.id)
    @company  = current_company
  end

  def update
    @settings = current_company.settings
    @company  = current_company

    if params[:company_setting]
      success = @settings.update_attributes(params[:company_setting])
    elsif params[:company]
      success = @company.update_attributes(params[:company])
    end

    if success
      redirect_to admin_settings_url, notice: t(".admin.notices.form_success")
    else
      render "show"
    end
  end
end
