require 'spec_helper'

feature "Adding and editing goods" do
  before do
    login_into_admin
  end

  pending "As a store admin, I'd like add goods to the inventory" do
    visit new_admin_inventory_good_url

    fill_in "good_name", with: "Goodyear truck tire"
    click_button "Salvar item"
    
    page.should have_content "Goodyear truck tire"
  end
end