require "spec_helper"

describe "Integrated store sale" do
  let(:cart) { ::Cart.create(environment: "website", company: @company) }

  before do
    @company  = FactoryGirl.create(:company_with_zipcode)
    @product  = FactoryGirl.create(:inventory_item, company: @company)
    @customer = FactoryGirl.create(:customer, store: @company)
  end

  describe "closing a sale" do
    it "creates an order in cash and decreases the product stock" do
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
      cart.add_item(@product.entries.second)

      # Closes the sale
      Store::Sale.new(cart, payment_type: "cash").close

      # Asserts
      entries.reload
      entries.first.quantity.should  == 8
      entries.second.quantity.should == 7
      entries.last.quantity.should   == 8
      entries.size.should            == 3

      Order.count.should == 1
      order = Order.first
      order.payment_type.should == "cash"
      order.total.to_s.should == "12.34"
    end

    it "creates an order in installments which has a different total" do
      # Executes
      #
      # Creates the cart and add some items
      cart.add_item(@product.entries.second)

      # Closes the sale
      Store::Sale.new(cart, payment_type: "installments").close
      Order.count.should == 1
      order = Order.first
      order.payment_type.should == "installments"
      order.total.to_s.should == "16.01"
    end
  end
end
