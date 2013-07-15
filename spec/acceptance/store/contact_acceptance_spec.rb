require "acceptance_spec_helper"

feature "Contact form" do
  background do
    # capybara-email gem
    clear_emails
  end

  scenario "As an user, I can contact the company via email" do
    @company = create(:company, contact: create(:contact, email: "contact@example.com"))
    stub_subdomain(@company)

    visit root_path
    click_link "contact_path"

    fill_in "contact_form_name", with: "General Zod"
    fill_in "contact_form_email", with: "zod@gmail.com"
    fill_in "contact_form_message", with: "This is my message to the world"
    click_button "submit"

    page.should have_content translation("store.contact.success.message")
    open_email("contact@example.com")

    current_email.should have_content "This is my message to the world"
  end

  scenario "As an user, I can't contact the company if it doesn't have" do
    @company = create(:company, contact: nil)
    stub_subdomain(@company)

    visit root_path
    page.should_not have_selector "#contact_path"
  end
end
