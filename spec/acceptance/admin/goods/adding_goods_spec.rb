require 'spec_helper'

feature "Adding and editing goods", js: true, search: true do
 
  before do
    @admin_user = Factory(:admin_user)
    Factory(:good_two)
    @good = Factory(:good, user: @admin_user, company: @admin_user.company)
    login_into_admin
  end

  context "existent goods" do
    scenario "As a store admin, I'd like to add items to the inventory" do
      visit new_good_or_balance_admin_inventory_goods_path

      fill_in "search_goods", with: @good.name
      wait_until { page.has_content?(@good.name) }

      click_link @good.name

      fill_in "good_balance_quantity", with: "4"
      fill_in "good_balance_cost_per_unit", with: "11"

      click_button "Cadastrar entrada no estoque"
      page.should have_content "R$ 11,00"
    end

    scenario "As a store admin, I'd like to add images to the goods" do
      image_path ="#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png" 
      
      visit admin_inventory_goods_path

      click_link @good.name

      click_link "Gerenciar imagens"
      within('.form-upload') do
        attach_file("good[images_attributes][0][image]",image_path)
        click_button "Enviar arquivos"
      end
      page.should have_content "Imagens atuais"
    end
  end

  context "inexistent goods" do
    scenario "As a store admin, I'd like add new goods to the inventory" do
      visit new_good_or_balance_admin_inventory_goods_path

      click_link "Criar novo bem"
      wait_until { page.has_content?("Nome do bem ou mercadoria") }

      fill_in "good_name", with: "Chocolate Cookies"
      fill_in "good_description", with: "Yammy Cookies"
      fill_in "good_reference", with: "192837465"

      click_button "Salvar item"

      page.should have_content "Chocolate Cookies"
    end
  end  
end
