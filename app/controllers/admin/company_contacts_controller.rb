class Admin::CompanyContactsController < Admin::ApplicationController
  def edit
    @company = current_company
    @company.build_address if @company.address.blank?
    @company.build_contact if @company.contact.blank?
  end

  def update
    @company = current_company
    if @company.update_attributes(params[:company])
      flash[:notice] = I18n.t("admin.default_messages.update.success")
      redirect_to edit_admin_company_contact_url
    else
      flash[:alert] = I18n.t("admin.default_messages.update.failure")
      render :edit
    end
  end
end
