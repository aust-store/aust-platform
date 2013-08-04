require 'acceptance_spec_helper'

feature "Company Settings", js: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    login_into_admin
  end

  describe "editing the company settings" do
    scenario "As a store admin, I want to change my company settings" do
      visit admin_settings_path

      page.should have_content I18n.t("simple_form.labels.company_setting.zipcode")
      fill_in "company_setting_zipcode", with: "12345678"

      click_link I18n.t("helpers.submit.company_setting.update")
      page.should have_content I18n.t("admin.default_messages.update.success")
    end
  end
end
