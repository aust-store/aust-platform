require 'acceptance_spec_helper'

feature "Inventory Item Management", search: true do
  before do
    login_into_admin
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
      page.should have_content "My item"
    end

    describe "defining what entries should be on sale", js: true do
      context "when item has many entries" do
        scenario "As a store admin, I want to configure which entries are on sale" do
          # entries with quantity 0 should not appear
          visit admin_inventory_item_path(@item)
          page.should_not have_content "R$ 11,00"
          page.should have_content "R$ 23,00"
          page.should have_content "R$ 12,00"

          visit store_path(@company.handle)
          page.should_not have_content "R$ 11,00"
          page.should have_content "R$ 23,00"
          page.should_not have_content "R$ 12,00"

          # selects the entry with price R$ 12,00
          visit admin_inventory_item_path(@item)
          find(".inventory_entry_on_sale.on_sale_#{@inventory_entry_two.id}").click
          page.should have_selector(".inventory_entry_on_sale.on_sale_#{@inventory_entry_two.id}")

          visit admin_inventory_item_path(@item)

          visit store_path(@company.handle)
          page.should_not have_content "R$ 11,00"
          page.should_not have_content "R$ 23,00"
          page.should have_content "R$ 12,00"
        end
      end
    end
  end
end