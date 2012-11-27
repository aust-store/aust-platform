require "unit_spec_helper"
require "store/cart"

describe Store::Cart do
  it_obeys_the "cart contract"
  it_obeys_the "cart item contract"
  it_obeys_the "cart items list contract"
  it_obeys_the "cart price calculation contract"
  it_obeys_the "cart update contract"

  let(:company)    { double }
  let(:cart_id)    { double }
  let(:cart_model) { double(find_or_create_cart: true) }
  let(:item)       { double(id: 1) }

  subject { Store::Cart.new(company, cart_id) }

  before do
    stub_const("Cart", cart_model)
  end

  describe "initialization" do
    it "persists the current cart" do
      Store::Cart.any_instance.should_receive(:persisted_cart)
      Store::Cart.new(company, nil)
    end
  end

  describe "#id" do
    it "returns the current session's id" do
      subject.stub(:persistence) { nil }
      subject.id.should == cart_id
    end

    it "returns the persistence's id if current session is nil" do
      subject = Store::Cart.new(company, nil)
      subject.stub_chain(:persistence, :id) { :id }
      subject.id.should == :id
    end

    it "returns nil if no persistence or session was set" do
      subject = Store::Cart.new(company, nil)
      subject.stub_chain(:persistence) { nil }
      subject.id.should == nil
    end
  end

  describe "#add_item" do
    let(:quantity) { double }
    let(:persisted_cart) { double(id: 1).as_null_object }

    before do
      subject.stub(:persistence) { persisted_cart }
    end

    it "deletes the current shipping calculation" do
      persisted_cart.should_receive(:reset_shipping)
      subject.add_item(item, quantity)
    end

    it "adds one item to the cart" do
      persisted_cart.should_receive(:add_item).with(item, quantity)
      subject.add_item(item, quantity)
    end
  end

  describe "#remove_item" do
    it "removes one item from the cart" do
      cart_items = double
      persisted_cart = double(id: 1, items: cart_items)
      subject.stub(:persistence) { persisted_cart }

      cart_items.should_receive(:destroy).with(1)
      subject.remove_item(1)
    end
  end

  describe "#current_items" do
    it "delegates the gathering of items to the LoadingItems object" do
      persisted_cart = double(id: 1)
      subject.stub(:persistence) { persisted_cart }

      items_display = double(list: [:item, :item])
      Store::Cart::ItemsList.stub(:new).with(subject) { items_display }

      subject.current_items.should == [:item, :item]
    end
  end

  describe "#all_items" do
    it "returns the items form the persisted cart" do
      persisted_cart = double(id: 1)
      subject.stub(:persistence) { persisted_cart }

      persisted_cart.stub_chain(:items, :all) { [:items] }
      subject.all_items.should == [:items]
    end
  end

  describe "#persisted_cart" do
    it "finds the current cart or creates a new" do
      subject = Store::Cart.new(company, cart_id)

      cart_model.should_receive(:find_or_create_cart).with(subject)
      subject.persisted_cart
    end
  end

  describe "#update" do
    let(:update) { double(update: :update) }

    it "updates the current cart" do
      update.stub(:new).with(subject) { update }
      stub_const("Store::Cart::Update", update)

      subject.update(:params).should == :update
    end
  end

  pending "#total_price"
  pending "#total_price_by_item"
end
