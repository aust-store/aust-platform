class Admin::StoreThemesController < Admin::ApplicationController
  def index
    @themes = Theme.order("id desc").public.all
  end

  def update
    theme = Theme.public.find(params[:id])
    current_company.update_attributes(theme_id: theme.id)

    redirect_to admin_store_themes_url, notice: I18n.t("admin.notices.store_themes.update")
  end
end
