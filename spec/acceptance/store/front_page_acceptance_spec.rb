# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company)

    inventory_entry_one   = FactoryGirl.create(:inventory_entry, price: 11.0)
    inventory_entry_two   = FactoryGirl.create(:inventory_entry, price: 23.0)
    inventory_entry_three = FactoryGirl.create(:inventory_entry, price: 12.0)
    @item = FactoryGirl.create(:inventory_item, company: @company, balances: [
                                 inventory_entry_one,
                                 inventory_entry_two,
                                 inventory_entry_three
                               ])
    inventory_entry_one.update_attribute(:quantity, 0)
  end

  describe "Accessing a company's store" do
    scenario "As a customer, I access a specific store" do
      visit store_path(@company.handle)
      page.should have_content(@company.name)

      within(".cart_status") do
        page.should have_content("Seu carrinho está vazio.")
      end

      # the correct price is shown
      page.should have_content @item.name
      page.should have_content "R$ 23,00"
    end
  end

  describe "Showing highlight products in the main page" do
    scenario "As a customer, I see a list of highlight products, max 12 results" do
      12.times do |i|
        inventory_entry = FactoryGirl.create(:inventory_entry, price: 20.0)
        FactoryGirl.create(:inventory_item, name: "Item #{i+1}", company: @company, balances: [inventory_entry])
      end

      visit store_path(@company.handle)
      page.should have_content(@company.name)

      n = 12
      12.times do |p|
        within(".product_#{p+1}") do
          page.should have_content "Item #{n}"
          page.has_css?("image_#{p+1}")
          page.should have_content "R$ 20,00"
          n -= 1
        end
      end
    end

    scenario "last products created are shown first" do
      visit store_path(@company.handle)
      page.should_not have_content "Item 1"
      page.should_not have_content "Item 2"

      login_into_admin
      image_path ="#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png"

      2.times do |n|

        visit new_admin_inventory_item_path(@company.handle)
        fill_in "inventory_item_name", with: "Item #{n+1}"
        click_button "Salvar item"

        click_link "Item #{n+1}"

        click_link "Nova entrada no estoque"
        fill_in "inventory_entry_quantity", with: 10
        fill_in "inventory_entry_cost_per_unit", with: 20
        fill_in "inventory_entry_price", with: 30
        click_button "submit_entry"

        click_link "Item #{n+1}"

        click_link "Gerenciar imagens"
        within('.form-upload') do
          attach_file("item[images][image]",image_path)
          click_button "Enviar arquivos"
        end

        new_item = InventoryItem.find_by_name("Item #{n+1}")
        new_item.images.first.update_attribute(:cover, true)
      end

      visit store_path(@company.handle)

      within(".product_1") do
        page.should have_content "Item 2"
        page.has_css?("image_1")
        page.should have_content "R$ 30,00"
      end

      within(".product_2") do
        page.should have_content "Item 1"
        page.has_css?("image_2")
        page.should have_content "R$ 30,00"
      end
    end

    scenario "redirects to sign in page when login into admin fails" do
      @admin_user = FactoryGirl.create( :admin_user,
                                        name: "wrongname",
                                        email: "email@email.com",
                                        password: 1234567890,
                                        password_confirmation: 1234567890,
                                        role: "founder"
                                      )
      login_into_admin
      current_path.should_not == admin_store_dashboard_path(@company)
      current_path.should == "/admin_users/sign_in"
    end
  end
end