require 'acceptance_spec_helper'

feature "Editing inventory entries" do
  let(:item) { create(:inventory_item,
                      user: @admin_user,
                      company: @admin_user.company,
                      total_entries: 1) }

  background do
    login_into_admin
    item

    visit admin_inventory_item_path(item)
  end

  describe "As an admin" do
    scenario "I edit one existing inventory item's entry" do
      item.entry_for_website_sale.should be_present
      item.entry_for_point_of_sale.should be_present

      within ".inventory_entries" do
        click_link "edit_entry"
      end

      find("#inventory_entry_website_sale").value.should == "1"
      find("#inventory_entry_point_of_sale").value.should == "1"

      uncheck("inventory_entry_website_sale")
      uncheck("inventory_entry_point_of_sale")
      click_on "Salvar"

      current_path.should == admin_inventory_item_path(item)
      item.reload
      item.entry_for_website_sale.should be_blank
      item.entry_for_point_of_sale.should be_blank
    end

    scenario "I delete an entry" do
      item.entries.count.should == 1
      within ".inventory_entries" do
        click_link "edit_entry"
      end

      click_link "delete_item"
      item.reload.entries.count.should == 0
      current_path.should == admin_inventory_item_path(item)
    end
  end

  describe "edge cases" do
    scenario "As an admin without POS, I can't see point of sale options" do
      Store::Policy::PointOfSale.stub_chain(:new, :enabled?) { false }

      within ".inventory_entries" do
        click_link "edit_entry"
      end

      page.should have_selector "#inventory_entry_website_sale"
      page.should_not have_selector "#inventory_entry_point_of_sale"
    end
  end
end
