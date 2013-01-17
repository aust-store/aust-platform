require 'acceptance_spec_helper'

feature "Inventory Item Management" do
  before do
    login_into_admin
    stub_subdomain(@company)

    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_item = FactoryGirl.create(:inventory_item, name: "Other item", user: @other_user, company: @other_company)

    Timecop.travel(Time.local(2012, 04, 21, 10, 0, 0)) do
      @inventory_entry_one = FactoryGirl.create(:inventory_entry, price: 11.0, on_sale: true)
    end
    Timecop.travel(Time.local(2012, 04, 21, 11, 0, 0)) do
      @inventory_entry_two = FactoryGirl.create(:inventory_entry, price: 23.0, on_sale: true)
    end
    Timecop.travel(Time.local(2012, 04, 21, 12, 0, 0)) do
      @inventory_entry_three = FactoryGirl.create(:inventory_entry, price: 12.0, on_sale: true)
    end

    @item = FactoryGirl.create(:inventory_item,
                               name: "My item",
                               user: @admin_user,
                               company: @company,
                               balances: [
                                 @inventory_entry_one,
                                 @inventory_entry_two,
                                 @inventory_entry_three
                               ])
    @inventory_entry_one.update_attribute(:quantity, 0)
  end

  describe "show page" do
    scenario "As a store admin, I want to see the basic item's details" do
      visit admin_inventory_item_path(@item)

      # Basic item informations
      page.should have_content "My item"
      page.should have_content "Lorem ipsum lorem"

      # Shipping Box
      translations = "admin.inventory.items.shipping_box"
      page.should have_content "18.5cm #{I18n.t("#{translations}.length")}"
      page.should have_content "14.5cm #{I18n.t("#{translations}.width")}"
      page.should have_content "5cm #{I18n.t("#{translations}.height")}"
      page.should have_content "#{I18n.t("#{translations}.box_weight")}: 10kg"
    end

    describe "defining what entries should be on sale", js: true do
      context "when item has many entries" do
        scenario "As a store admin, I want to configure which entries are on sale" do
          # entries with quantity 0 should not appear
          visit admin_inventory_item_path(@item)
          page.should_not have_content "R$ 11,00"
          page.should have_content     "R$ 23,00"
          page.should have_content     "R$ 12,00"

          visit root_path
          page.should_not have_content "R$ 11,00"
          page.should have_content     "R$ 23,00"
          page.should_not have_content "R$ 12,00"

          # selects the entry with price R$ 12,00
          visit admin_inventory_item_path(@item)
          find(".inventory_entry_on_sale.on_sale_#{@inventory_entry_two.id}").click
          page.should have_selector(".inventory_entry_on_sale.on_sale_#{@inventory_entry_two.id}")

          visit admin_inventory_item_path(@item)

          visit root_path
          page.should_not have_content "R$ 11,00"
          page.should_not have_content "R$ 23,00"
          page.should have_content     "R$ 12,00"
        end
      end
    end

    describe "last products created are shown first in main page" do
      context "only the first defined entry will be shown per item" do
        scenario  "As an admin, I want the last product created to be displayed first in my store's main page listing" do
          visit root_path
          page.should_not have_content "Item 0"
          page.should_not have_content "Item 1"

          2.times do |n|
            visit new_admin_inventory_item_path(@company.handle)
            fill_in "inventory_item_name", with: "Item #{n}"

            fill_in "inventory_item_shipping_box_attributes_length", with: 23
            fill_in "inventory_item_shipping_box_attributes_width",  with: 23
            fill_in "inventory_item_shipping_box_attributes_height", with: 23
            fill_in "inventory_item_shipping_box_attributes_weight", with: 23

            click_button "Salvar item"

            click_link "Item #{n}"

            click_link "Nova entrada no estoque"
            fill_in "inventory_entry_quantity",      with: 10
            fill_in "inventory_entry_cost_per_unit", with: 20
            fill_in "inventory_entry_price",         with: 30
            click_button "submit_entry"

            click_link "Item #{n}"

            click_link "Gerenciar imagens"
            image_path = "#{Rails.root.to_s}/app/assets/images/store/icons/top_empty_cart.png"
            within('.form-upload') do
              attach_file("item[images][image]", image_path)
              click_button "Enviar arquivos"
            end

            new_item = InventoryItem.find_by_name("Item #{n}")
            new_item.images.first.update_attribute(:cover, true)
          end

          visit root_path
          within(".product_0") do
            page.should have_content "Item 1"
            page.has_css?("image_0")
            page.should have_content "R$ 30,00"
          end

          within(".product_1") do
            page.should have_content "Item 0"
            page.has_css?("image_1")
            page.should have_content "R$ 30,00"
          end
        end
      end
    end

    describe "products not shown for sale on main page" do
      scenario "items without a valid shipping box, do not appears on mais page" do
        visit root_path
        page.should have_content "My item"

        visit edit_admin_inventory_item_path(@item)
        fill_in "inventory_item_shipping_box_attributes_length", with: ""
        fill_in "inventory_item_shipping_box_attributes_width",  with: ""
        fill_in "inventory_item_shipping_box_attributes_height", with: ""
        fill_in "inventory_item_shipping_box_attributes_weight", with: ""
        click_button "Salvar item"

        visit root_path
        page.should_not have_content "My item"
      end

      scenario "items without a cover image, do not appears on mais page " do
        visit root_path
        page.should have_content "My item"

        new_item = InventoryItem.find_by_name("My item")
        new_item.images.each do |img|
          img.cover = false
          new_item.save
        end

        visit root_path
        page.should_not have_content "My item"
      end
    end
  end
end