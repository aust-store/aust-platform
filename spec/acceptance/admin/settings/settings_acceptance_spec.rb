require 'acceptance_spec_helper'

feature "Managing company settings" do
  before do
    @admin_user = create(:admin_user, api_token: "api_token_hash")
    login_into_admin
  end

  describe "editing the company settings" do
    scenario "As a store admin, I want to change my company settings" do
      visit admin_settings_path

      # Asserting present data
      page.should have_content "API Token: api_token_hash"

      # Editing the data
      #
      # Zipcode
      fill_in "company_setting_zipcode", with: "12345678"

      # Google Analytics
      fill_in "company_setting_google_analytics_id", with: "UA-45491111-1"

      click_on I18n.t("helpers.submit.company_setting.update")
      page.should have_content I18n.t("admin.default_messages.update.success")

      # Results
      #
      # Form
      find("#company_setting_zipcode").value.should == "12345678"
      find("#company_setting_google_analytics_id").value.should == "UA-45491111-1"

      # Database-level
      settings = CompanySetting.first
      settings.zipcode.should == "12345678"
      settings.google_analytics_id.should == "UA-45491111-1"
    end
  end
end
