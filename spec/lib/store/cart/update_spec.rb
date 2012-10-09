require "unit_spec_helper"
require "store/cart/update"

describe Store::Cart::Update do
  let(:cart) { double(persistence: cart_persistence) }
  let(:cart_persistence) { double }

  let(:params) do
    { "item_quantities" => { "10" => "3.2", "18" => "0.2" } }
  end

  it_obeys_the "cart contract"

  subject { Store::Cart::Update.new(cart) }

  describe "#update" do
    context "quantity" do
      it "updates the quantity" do
        params = { "item_quantities" => { "10" => "3.2", "11" => "5.1" } }

        cart_persistence
          .should_receive(:update_quantities_in_batch)
          .with("10" => 3, "11" => 5)

        subject.update(params)
      end
    end
  end
end
