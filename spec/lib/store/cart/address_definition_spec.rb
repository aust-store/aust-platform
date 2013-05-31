require "store/cart/address_definition"

describe Store::Cart::AddressDefinition do
  let(:user)       { double(default_address: double(copied: :user_address)) }
  let(:controller) { double(current_user: user) }
  let(:cart)       { double }

  subject { described_class.new(controller, cart) }

  describe "#use_users_default_address" do
    let(:shipping_address) { double }

    it "deletes the current address and builds a new one" do
      cart.stub(:shipping_address) { shipping_address }

      shipping_address.should_receive(:destroy)
      cart.should_receive(:build_shipping_address).with(:user_address)
      cart.should_receive(:save)

      subject.use_users_default_address
    end
  end
end
