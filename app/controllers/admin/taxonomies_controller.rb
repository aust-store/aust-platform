class Admin::TaxonomiesController < Admin::ApplicationController
  def index
    @taxonomies = current_company.taxonomies.hash_tree
    @taxonomy = Taxonomy.new
  end

  def create
    @taxonomy = current_company.taxonomies.new(params[:taxonomy])
    flash = if @taxonomy.save
              { notice: I18n.t("admin.default_messages.create.success") }
            else
              { alert: I18n.t("admin.default_messages.create.failure") }
            end
    redirect_to admin_taxonomies_path, flash
  end

  def update
    @taxonomy = current_company.taxonomies.friendly.find(params[:id])
    flash = if @taxonomy.update_attributes(params[:taxonomy])
              { notice: I18n.t("admin.default_messages.update.success") }
            else
              { alert: I18n.t("admin.default_messages.update.failure") }
            end
    redirect_to admin_taxonomies_path, flash
  end

  def destroy
    current_company.taxonomies.friendly.find(params[:id]).destroy
    redirect_to admin_taxonomies_path, notice: I18n.t("admin.default_messages.delete.success")
  end
end
