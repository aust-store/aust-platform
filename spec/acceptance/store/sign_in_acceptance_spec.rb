# encoding: utf-8
require "acceptance_spec_helper"

feature "Store Sign In" do
  before do
    @company = FactoryGirl.create(:company, :minimalism_theme)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    stub_subdomain(@company)
  end

  scenario "As a customer, I can access a sign in form and go " + \
           "to the sign up page", js: true do
    visit root_path

    within ".user_and_cart_status .user_status" do
      click_on "Login"
    end

    page.should have_selector "#customer_email"
    page.should have_selector "#customer_password"
    page.should have_selector "#sign_in"

    fill_in "customer_email", with: "customer@example.com"
    choose("has_no_password")
    click_on "sign_in"
    expect(current_path).to eq(new_customer_registration_path)
  end

  scenario "As an signed out customer, I can sign in from the home page" do
    customer = FactoryGirl.create(:customer)
    visit root_path

    within ".user_and_cart_status .user_status" do
      click_on "Login"
    end

    expect(current_path).to eq(new_customer_session_path)
    fill_in "customer_email",    with: customer.email
    fill_in "customer_password", with: "123456"
    click_on "sign_in"

    expect(current_path).to eq(root_path)

    within ".user_and_cart_status .user_status" do
      page.should have_content "Olá, #{customer.first_name}"
      click_on "Sair"
    end

    expect(current_path).to eq(root_path)
    within ".user_and_cart_status .user_status" do
      page.should have_content "Olá. Já é cadastrado?"
    end
  end
end
