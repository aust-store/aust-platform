require 'acceptance_spec_helper'

feature "Company Handles", js: true do
  scenario "Users should choose only alphanumeric handles" do
    visit new_admin_user_registration_path

    fill_in "handle", with: "my-pet"
    page.should have_content "http://my-pet.store.com"
  end
end
