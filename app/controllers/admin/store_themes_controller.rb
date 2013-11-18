class Admin::StoreThemesController < Admin::ApplicationController
  def index
    @themes = Theme.order("id desc").accessible_for_company(current_company).to_a
  end

  def create
    Theme.create_for_company(current_company)

    redirect_to admin_store_themes_url
  end

  def update
    theme = Theme.accessible_for_company(current_company).find(params[:id])
    current_company.update_attributes(theme_id: theme.id)

    redirect_to admin_store_themes_url, notice: I18n.t("admin.notices.store_themes.update")
  end
end
