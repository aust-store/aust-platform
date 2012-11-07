require 'acceptance_spec_helper'

feature "Adding Inventory Entries", js: true, search: true do
  before do
    login_into_admin
    FactoryGirl.create(:inventory_item, company: @company)
    @item = FactoryGirl.create(:inventory_item,
                               user: @admin_user,
                               company: @company)
  end

  context "existent inventory items" do
    scenario "As a store admin, I'd like to create inventory entries" do
      visit new_item_or_entry_admin_inventory_items_path

      fill_in "search_inventory_items", with: @item.name
      wait_until { page.has_content?(@item.name) }

      click_link @item.name

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
      click_link "Estoque"
      click_link "Adicionar item"

      fill_in "search_inventory_items", with: "My backpack"
      find("#search_inventory_items").value.should == "My backpack"

      wait_until(30) { page.has_content?("Criar um novo item") }
      click_link "Criar um novo item"
      wait_until(30) { page.has_content?("Nome do item ou mercadoria") }

      fill_in "inventory_item_name", with: "Chocolate Cookies"
      fill_in "inventory_item_description", with: "Yammy Cookies"
      fill_in "inventory_item_reference", with: "192837465"

      click_button "Salvar item"

      page.should have_content "Chocolate Cookies"
    end
  end
end
