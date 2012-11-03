require 'acceptance_spec_helper'

feature "Inventory Item Management", search: true do
  before do
    login_into_admin
    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_good = FactoryGirl.create(:good, name: "Other good", user: @other_user, company: @other_company)

    @inventory_entry_one   = FactoryGirl.create(:inventory_entry, price: 11.0)
    @inventory_entry_two   = FactoryGirl.create(:inventory_entry, price: 23.0)
    @inventory_entry_three = FactoryGirl.create(:inventory_entry, price: 12.0)
    @good = FactoryGirl.create(:good,
                               name: "My good",
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
      visit admin_inventory_good_path(@good)
      page.should have_content "My good"
    end

    describe "defining what entries should be on sale", js: true do
      context "when item has many entries" do
        scenario "As a store admin, I want to configure which entries are on sale" do
          # entries with quantity 0 should not appear
          visit admin_inventory_good_path(@good)
          page.should_not have_content "R$ 11,00"
          page.should have_content "R$ 23,00"
          page.should have_content "R$ 12,00"

          visit store_path(@company.handle)
          page.should_not have_content "R$ 11,00"
          page.should have_content "R$ 23,00"
          page.should_not have_content "R$ 12,00"

          # selects the entry with price R$ 12,00
          visit admin_inventory_good_path(@good)
          find(".inventory_entry_on_sale.on_sale_#{@inventory_entry_two.id}").click

          visit store_path(@company.handle)
          page.should_not have_content "R$ 11,00"
          page.should_not have_content "R$ 23,00"
          page.should have_content "R$ 12,00"

        end
      end
    end
  end
end
