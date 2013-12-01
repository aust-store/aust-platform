require 'acceptance_spec_helper'

feature "Admin User sessions" do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    stub_subdomain(@admin_user.company)
  end

  context "Successfully signed in" do
    scenario "As an admin, I'd like to sign in into my store admin" do
      visit new_admin_user_session_path

      within("form#new_admin_user") do
        fill_in "admin_user_email", with: @admin_user.email
        fill_in "admin_user_password", with: "1234567"

        page.should have_selector "#admin_user_email"
        page.should have_selector "#admin_user_password"
      end
      click_button "sign_in"

      page.should have_content "Estoque"

      current_path.should == admin_dashboard_path
    end
  end

  context "Failure in sign in" do
    scenario "User must be in its company's subdomain" do
      visit new_admin_user_session_path
      @admin_user.company_id = 9999
      @admin_user.save

      within("form#new_admin_user") do
        fill_in "admin_user_email", with: @admin_user.email
        fill_in "admin_user_password", with: "1234567"

        page.should have_selector "#admin_user_email"
        page.should have_selector "#admin_user_password"
      end
      click_button "sign_in"

      current_path.should_not == admin_store_dashboard_path
      current_path.should == new_admin_user_session_path
    end

    scenario "Redirects the user to sign in page when login into admin fails" do
      visit new_admin_user_session_path

      within("form#new_admin_user") do
        fill_in "admin_user_email", with: @admin_user.email
        fill_in "admin_user_password", with: "12345678"

        page.should have_selector "#admin_user_email"
        page.should have_selector "#admin_user_password"
      end
      click_button "sign_in"

      current_path.should_not == admin_store_dashboard_path
      current_path.should == new_admin_user_session_path
    end
  end

  describe "cross subdomain session" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
    let(:company)    { admin_user.company }
    let(:company2)   { FactoryGirl.create(:admin_user).company }

    background do
      company2
      stub_subdomain(company)
      login_into_admin(as: admin_user)
    end

    scenario "As signed in admin, I'm logged out when going to another subdomain" do
      current_url.should == admin_dashboard_url(subdomain: company.handle, domain: "lvh.me")

      visit admin_dashboard_url(subdomain: company2.handle)
      current_url.should == new_admin_user_session_url(subdomain: company2.handle)
    end
  end

  describe "loggin out" do
    scenario "As signed in admin, I can sign out" do
      login_into_admin(as: @admin_user)
      click_link "sign_out"
      current_url.should == new_admin_user_session_url(subdomain: @admin_user.company.handle, domain: "lvh.me")
    end
  end
end
