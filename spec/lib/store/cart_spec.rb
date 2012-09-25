require "unit_spec_helper"
require "store/cart"

describe Store::Cart do
  it_obeys_the "cart item contract"
  it_obeys_the "cart price calculation contract"

  let(:company) { double }
  let(:cart_id) { double }
  let(:cart_model) { double }
  let(:item) { double(id: 1) }

  subject { Store::Cart.new(company, cart_id) }

  before do
    stub_const("Cart", cart_model)
    stub_const("ActiveRecord::RecordNotFound", Exception.new)
  end

  describe "initialization" do
    it "creates a new cart in the database if it doesn't exist" do
      cart_model.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      Cart.should_receive(:create).with(company: company)
      Store::Cart.new(company, nil)
    end

    it "loads an existing cart" do
      Cart.should_receive(:find).with(cart_id)
      Cart.should_not_receive(:create)
      Store::Cart.new(company, cart_id)
    end
  end

  describe "#id" do
    it "returns the persistence's id" do
      Cart.stub(:find) { double(id: 1) }
      subject.id.should == 1
    end
  end

  describe "#add_item" do
    it "adds one item to the cart" do
      quantity = double
      persisted_cart = double(id: 1)

      Cart.stub(:find) { persisted_cart }

      persisted_cart.should_receive(:add_item).with(item, quantity)
      subject.add_item(item, quantity)
    end
  end

  describe "#items" do
    it "returns the items form the persisted cart" do
      persisted_cart = double(id: 1)

      Cart.stub(:find) { persisted_cart }

      persisted_cart.stub_chain(:items, :all) { [:items] }
      subject.items.should == [:items]
    end
  end

  pending "#total_price"
  pending "#total_price_by_item"
end
