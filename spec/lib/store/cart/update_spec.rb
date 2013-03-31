require "unit_spec_helper"
require "store/cart/update"

describe Store::Cart::Update do
  let(:cart)  { double(persistence: cart_persistence) }
  let(:item1) { double(id: 10) }
  let(:item2) { double(id: 11) }
  let(:cart_persistence) { double(items: [item1, item2]) }

  let(:params) do
    { "item_quantities" => { "10" => "3.2", "18" => "0.2" } }
  end

  it_obeys_the "cart contract"

  subject { Store::Cart::Update.new(cart) }

  describe "#update" do
    context "quantity" do
      it "updates the quantity" do
        params = { "item_quantities" => { "10" => "3.2", "11" => "5.1" } }

        item1.should_receive(:update_quantity).with(3)
        item2.should_receive(:update_quantity).with(5)

        subject.update(params)
      end
    end
  end
end
