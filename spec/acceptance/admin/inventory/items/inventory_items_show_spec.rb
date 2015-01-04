# encoding: utf-8
require 'acceptance_spec_helper'

feature "Inventory Item Management" do
  before do
    login_into_admin
    stub_subdomain(@company)

    @other_user = create(:admin_user)
    @other_company = @other_user.company
    @other_item = create(:inventory_item,
                         name: "Other item",
                         user: @other_user,
                         company: @other_company)

    create(:custom_field, name: "Notes", company: @company)

    @item = create(:inventory_item_for_sale_without_entry,
                   name: "My item",
                   user: @admin_user,
                   custom_fields: {"notes" => "Notass"},
                   company: @company)

    Timecop.travel(Time.local(2012, 04, 21, 10, 0, 0)) do
      create(:inventory_entry,
             store_id: @company.id,
             on_sale: true,
             inventory_item_id: @item.id)
    end
    Timecop.travel(Time.local(2012, 04, 21, 11, 0, 0)) do
      create(:inventory_entry,
             store_id: @company.id,
             on_sale: true,
             inventory_item_id: @item.id)
    end
    Timecop.travel(Time.local(2012, 04, 21, 12, 0, 0)) do
      create(:inventory_entry,
             store_id: @company.id,
             on_sale: true,
             inventory_item_id: @item.id)
    end

    @item.entries.first.update_attribute(:quantity, 0)
  end

  describe "As an admin on item's show page" do
    scenario "I want to see the details of an item" do
      create(:taxonomy)
      @item.taxonomy = Taxonomy.all.last
      taxonomy = @item.taxonomy
      @item.save

      visit admin_inventory_item_path(@item)

      # Basic item informations
      page.should have_content "My item"
      page.should have_content "ID único interno: ##{@item.id}"
      page.should have_content "Lorem ipsum lorem"
      page.should have_content "Notes: Notass"
      page.should have_content "Categoria: #{taxonomy.parent.name} ► #{taxonomy.name}"

      # Shipping Box
      translations = "admin.inventory.items.shipping_box"
      page.should have_content "18.5cm #{I18n.t("#{translations}.length")}"
      page.should have_content "14.5cm #{I18n.t("#{translations}.width")}"
      page.should have_content "5cm #{I18n.t("#{translations}.height")}"
      page.should have_content "#{I18n.t("#{translations}.box_weight")}: 10kg"
    end

    scenario "I delete an item" do
      visit admin_inventory_item_path(@item)
      click_link "delete_item"
      current_path.should == admin_inventory_items_path
      expect { @item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "when item has many entries" do
      scenario "I configure which entries are on sale" do
        visit root_path
        page.should have_content "R$ 12,34"

        # entries with quantity 0 should not appear
        visit admin_inventory_item_path(@item)
        page.should have_content "R$ 12,34"


        # deselects the entry with price R$ 12,00
        uncheck("inventory_item_entries_attributes_0_on_sale")
        uncheck("inventory_item_entries_attributes_1_on_sale")
        uncheck("inventory_item_entries_attributes_2_on_sale")
        within "#entries_on_sale" do
          click_on "save_entries"
        end
        page.should have_content "R$ 12,34"

        @item.entries.pluck(:on_sale).should == [false, false, false]

        visit root_path
        page.should_not have_content "R$ 12,34"
      end
    end

    context "when item has only one entry" do
      scenario "I configure whether it's on sale or not" do
        first_entry = @item.entries.all_entries_elligible_for_sale.first
        @item.entries.where("inventory_entries.id NOT IN (?)", first_entry.id).destroy_all

        visit root_path
        page.should have_content "R$ 12,34"

        # admin, item's page
        visit admin_inventory_item_path(@item)
        @item.entries.reload.pluck(:on_sale).should == [true]
        # deselects the only entry
        click_button "switch_on_sale"

        @item.entries.pluck(:on_sale).should == [false]

        # stop showing up in the store
        visit root_path
        page.should_not have_content "R$ 12,34"

        # admin, item's page again
        visit admin_inventory_item_path(@item)
        # deselects the only entry
        click_button "switch_on_sale"
        @item.entries.reload.pluck(:on_sale).should == [true]

        # shows up in the store again
        visit root_path
        page.should have_content "R$ 12,34"
      end
    end

    # FIXME why is this spec here? It's not admin related.
    describe "last products created are shown first in main page" do
      context "only the first defined entry will be shown per item" do
        scenario  "As an admin, I want the last product created to be displayed first in my store's main page listing" do
          item1 = create(:inventory_item, company: @company)
          item2 = create(:inventory_item, company: @company)

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

        # Removes all cover images from the DB
        InventoryItem.find_by_name(@item.name).images.cover.to_a.each do |e|
          e.update_attributes(cover: false)
        end

        # Removes the current item's shipping box
        visit edit_admin_inventory_item_path(@item)
        fill_in "inventory_item_shipping_box_attributes_length", with: ""
        fill_in "inventory_item_shipping_box_attributes_width",  with: ""
        fill_in "inventory_item_shipping_box_attributes_height", with: ""
        fill_in "inventory_item_shipping_box_attributes_weight", with: ""
        click_button "Salvar item"

        # Item's show page
        page.current_path.should == admin_inventory_item_path(@item)
        page.should have_content "Motivo: Não possui caixa para frete definida"
        page.should have_content "Motivo: Não possui imagem de capa"
      end
    end
  end
end
