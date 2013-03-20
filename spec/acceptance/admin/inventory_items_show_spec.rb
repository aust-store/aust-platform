# encoding: utf-8
require 'acceptance_spec_helper'

feature "Inventory Item Management" do
  before do
    login_into_admin
    stub_subdomain(@company)

    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_item = FactoryGirl.create(:inventory_item,
                                     name: "Other item",
                                     user: @other_user,
                                     company: @other_company)

    @item = FactoryGirl.create(:inventory_item_for_sale_without_entry,
                               name: "My item",
                               user: @admin_user,
                               company: @company)

    Timecop.travel(Time.local(2012, 04, 21, 10, 0, 0)) do
      @item.entries.build FactoryGirl.attributes_for(:inventory_entry,
                                                     store_id: @company.id,
                                                     on_sale: true)
      @item.save
    end
    Timecop.travel(Time.local(2012, 04, 21, 11, 0, 0)) do
      @item.entries.build FactoryGirl.attributes_for(:inventory_entry,
                                                     store_id: @company.id,
                                                     on_sale: true)
      @item.save
    end
    Timecop.travel(Time.local(2012, 04, 21, 12, 0, 0)) do
      @item.entries.build FactoryGirl.attributes_for(:inventory_entry,
                                                     store_id: @company.id,
                                                     on_sale: true)
      @item.save
    end

    @item.entries.first.update_attribute(:quantity, 0)
  end

  describe "show page" do
    scenario "As a store admin, I want to see the basic item's details" do
      FactoryGirl.create(:taxonomy)
      @item.taxonomy = Taxonomy.all.last
      taxonomy = @item.taxonomy
      @item.save

      visit admin_inventory_item_path(@item)

      # Basic item informations
      page.should have_content "My item"
      page.should have_content "Lorem ipsum lorem"
      page.should have_content "Categoria: #{taxonomy.parent.name} ► #{taxonomy.name}"

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
          page.should have_content     "R$ 12,34"

          visit root_path
          page.should have_content     "R$ 12,34"

          # deselects the entry with price R$ 12,00
          visit admin_inventory_item_path(@item)
          find(".inventory_entry_on_sale.on_sale_#{@item.entries.second.id}").click
          page.should have_selector(".inventory_entry_on_sale.on_sale_#{@item.entries.second.id}")

          visit root_path
          page.should have_content "R$ 12,34"
        end
      end
    end

    # FIXME why is this spec here? It's not admin related.
    describe "last products created are shown first in main page" do
      context "only the first defined entry will be shown per item" do
        scenario  "As an admin, I want the last product created to be displayed first in my store's main page listing" do
          item1 = FactoryGirl.create(:inventory_item, company: @company)
          item2 = FactoryGirl.create(:inventory_item, company: @company)

          visit root_path
          within(".product_0") do
            page.should have_content item2.name
            page.has_css?("image_0")
            page.should have_content "R$ 12,34"
          end

          within(".product_1") do
            page.should have_content item1.name
            page.has_css?("image_1")
            page.should have_content "R$ 12,34"
          end
        end
      end
    end

    describe "products not shown for sale on main page" do
      scenario "items without a valid shipping box, do not appears on main page" do
        visit root_path
        page.should have_content "My item"

        visit edit_admin_inventory_item_path(@item)
        fill_in "inventory_item_shipping_box_attributes_length", with: ""
        fill_in "inventory_item_shipping_box_attributes_width",  with: ""
        fill_in "inventory_item_shipping_box_attributes_height", with: ""
        fill_in "inventory_item_shipping_box_attributes_weight", with: ""
        click_button "Salvar item"

        # Item's show page
        page.current_path.should == admin_inventory_item_path(@item)
        page.should have_content "Motivo: Não possui caixa para frete definida"

        visit root_path
        page.should_not have_content "My item"
      end

      scenario "items without a cover image, do not appears on main page" do
        visit root_path
        page.should have_content "My item"

        new_item = InventoryItem.find_by_name("My item")
        new_item.images.each do |img|
          img.cover = false
          new_item.save
        end

        visit admin_inventory_item_path(@item)
        page.should have_content "Motivo: Não possui imagem de capa"

        visit root_path
        page.should_not have_content "My item"
      end
    end
  end
end
