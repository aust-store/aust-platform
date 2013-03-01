require "contracts/lib/store/item_price_contract"
require "store/item_price"
require "active_support/all"

describe Store::ItemPrice do
  it_behaves_like "item price contract"

  let(:prices) { [double(value: 1), double(value: 2)] }
  let(:item)   { double(prices: prices) }

  subject { Store::ItemPrice.new(item) }

  describe "#price" do
    it "returns the first entry's price" do
      expect(subject.price).to eql(2)
    end

    it "returns nil if entry's price is nil" do
      prices.stub(:last) { nil }
      expect(subject.price).to eq 0
    end
  end
end
