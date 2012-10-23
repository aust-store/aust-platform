require 'acceptance_spec_helper'

feature "Adding and editing goods", js: true, search: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    FactoryGirl.create(:good_with_company)
    @good = FactoryGirl.create(:good, user: @admin_user, company: @admin_user.company)
    login_into_admin
  end

  context "existent inventory items" do
    scenario "As a store admin, I'd like to create inventory entries" do
      visit new_good_or_entry_admin_inventory_goods_path

      fill_in "search_inventory_items", with: @good.name
      wait_until { page.has_content?(@good.name) }

      click_link @good.name

      fill_in "inventory_entry_quantity", with: "4"
      fill_in "inventory_entry_cost_per_unit", with: "11"
      fill_in "inventory_entry_price", with: "14"

      click_button "Cadastrar entrada no estoque"
      page.should have_content "R$ 11,00"
      page.should have_content "R$ 14,00"
    end
  end

  context "inexistent inventory items" do
    scenario "As a store admin, I'd like add new item to the inventory" do
      visit new_good_or_entry_admin_inventory_goods_path

      fill_in "search_inventory_items", with: "Backpack"
      click_link "Criar um novo item"
      wait_until { page.has_content?("Nome do bem ou mercadoria") }

      fill_in "good_name", with: "Chocolate Cookies"
      fill_in "good_description", with: "Yammy Cookies"
      fill_in "good_reference", with: "192837465"

      click_button "Salvar item"

      page.should have_content "Chocolate Cookies"
    end
  end
end
