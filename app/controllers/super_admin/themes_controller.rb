class SuperAdmin::ThemesController < SuperAdmin::ApplicationController
  def index
    @themes = Theme.all
  end

  def new
    @theme = Theme.new
  end

  def edit
    @theme = Theme.find(params[:id])
  end

  def create
    @theme = Theme.new(params[:theme])

    if @theme.save
      redirect_to super_admin_themes_url, notice: I18n.t("saved_successfully")
    else
      render action: "new"
    end
  end

  def update
    @theme = Theme.find(params[:id])

    if @theme.update_attributes(params[:theme])
      redirect_to super_admin_themes_url, notice: I18n.t("saved_successfully")
    else
      render action: "edit"
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    redirect_to super_admin_themes_url, notice: I18n.t("admin.default_messages.delete.success")
  end
end
