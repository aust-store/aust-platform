class Admin::SettingsController < Admin::ApplicationController
  def show
    @settings = CompanySetting.find_or_create_by_company_id(current_company.id)
  end

  def update
    @settings = current_company.settings
    if @settings.update_attributes(params[:company_setting])
      redirect_to admin_settings_url, notice: t(".admin.javascript.form_success")
    else  
      render "show"
    end
  end
end