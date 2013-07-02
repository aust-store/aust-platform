# encoding: utf-8
require 'acceptance_spec_helper'

feature "Stores" do
  background do
    login_into_super_admin
  end

  scenario "As a super admin, I can see the existent stores" do
    company1 = FactoryGirl.create(:company)
    company2 = FactoryGirl.create(:company)
    click_link "Lojas"

    page.should have_content company1.name
    page.should have_content company1.handle
    page.should have_content company2.name
    page.should have_content company2.handle
  end
end
