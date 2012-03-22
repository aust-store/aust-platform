require 'spec_helper'

feature "Listing goods' balance", js: true, search: true do
  background do
    @other_user = Factory(:admin_user)
    @other_company = @other_user.company
    @other_good = Factory(:good, name: "Other good", user: @other_user, company: @other_company)

    @admin_user = Factory(:admin_user)
    @good = Factory(:good, name: "My good", user: @admin_user, company: @admin_user.company)
    10.times { |t| Factory(:good_balance_lite, description: "Balance #{t+1}", quantity: (t+1), good: @good, admin_user: @admin_user) }

    login_into_admin
  end

  describe "list of a good's current balance" do
    before do
      visit admin_inventory_good_balances_path(@good)
    end

    scenario "As a store admin, I want to see goods from my company only" do
      page.should have_content "Balance 1"
      page.should have_content "Balance 2"
      page.should have_content "Balance 3"
      page.should have_content "Balance 4"
      page.should have_content "Balance 5"
      page.should have_content "Balance 6"
      page.should have_content "Balance 7"
      page.should have_content "Balance 8"
      page.should have_content "Balance 9"
      page.should have_content "Balance 10"
      page.should_not have_content "Other good"
    end
  end

  describe "add good's balance" do
    before do
      visit new_admin_inventory_good_balance_path(@good)
    end

    def add_balance
      fill_in "good_balance_description", with: "A new balance status."
      fill_in "good_balance_quantity", with: "5"
      fill_in "good_balance_cost_per_unit", with: "R$ 1.30"
      click_on "submit_balance"
    end

    scenario "As a store admin, I want to see the balance I just added" do
      add_balance
      
      page.current_path.should == admin_inventory_good_balances_path(@good)

      page.should have_content "A new balance status."
      page.should have_content "R$ 1,30"
      page.should_not have_content "Other good"
    end
  end
end

