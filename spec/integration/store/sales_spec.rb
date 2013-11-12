require "spec_helper"

describe "Integrated store sale" do
  before do
    @company  = FactoryGirl.create(:company_with_zipcode)
    @product  = FactoryGirl.create(:inventory_item, company: @company)
    @customer = FactoryGirl.create(:customer, store: @company)
  end

  describe "closing a sale" do
    it "creates an order and decreases the product stock" do

      # Prepares
      entries = @product.entries.order('id asc')
      entries.first.quantity.should  == 8
      entries.second.quantity.should == 8
      entries.last.quantity.should   == 8
      entries.size.should            == 3

      Order.count.should == 0

      # Executes
      #
      # Creates the cart and add some items
      cart = ::Cart.create(environment: "website", company: @company)
      cart.add_item(@product.entries.second)

      # Closes the sale
      Store::Sale.new(cart).close

      # Asserts
      entries.reload
      entries.first.quantity.should  == 8
      entries.second.quantity.should == 7
      entries.last.quantity.should   == 8
      entries.size.should            == 3

      Order.count.should == 1
    end
  end
end
