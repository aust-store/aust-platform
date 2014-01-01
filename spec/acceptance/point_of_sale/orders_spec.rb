require 'acceptance_spec_helper'

feature "Point of sale's orders", js: true do
  background do
    login_into_admin
    @item = FactoryGirl.create(:inventory_item, company: @company)
    @user = FactoryGirl.create(:customer, first_name: "Luke", last_name: "Skywalker", store: @company)
    click_link "go_to_point_of_sale"
  end

  describe "creating an order" do
    before do
      # there are no orders in the database
      Order.count.should == 0
    end

    it "As a salesman, I'd like to add new items to the cart" do
      within "#main" do
        page.should have_content "Novo pedido"

        # searches for the item
        fill_in "inventory_item_search", with: "good"
        page.should have_content "Goodyear tire 4 inches"

        # adds item into the cart
        click_link @item.name
        page.should have_content "R$ 12,34"

        # searches for the customer
        fill_in "customer_search", with: "luk"
        page.should have_content "Luke"

        # adds item into the cart
        click_link @user.first_name
        page.should have_content "Luke Skywalker"

        # closes the sale
        click_link "place_order"

        # page is reset
        page.should_not have_content @item.name # goodyear
        page.should_not have_content "Luke" # goodyear
        page.should_not have_selector "#place_order"
      end
    end
  end
end
