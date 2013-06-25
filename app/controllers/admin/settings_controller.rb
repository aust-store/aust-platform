class Admin::SettingsController < Admin::ApplicationController
  def show
    @settings = CompanySetting.where(company_id: current_company.id).first_or_create
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
      redirect_to admin_settings_url, notice: I18n.t("admin.default_messages.update.success")
    else
      render "show"
    end
  end
end
