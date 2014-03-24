require "contracts/lib/store/item_price_contract"
require "store/item_price"
require "active_support/all"
require "money"

describe Store::ItemPrice do
  it_behaves_like "item price contract"

  let(:price1) { double(value: 1, for_installments: 3) }
  let(:price2) { double(value: 2, for_installments: 4) }
  let(:prices) { [price1, price2] }
  let(:item)   { double(prices: prices) }

  subject { Store::ItemPrice.new(item) }

  describe "#price" do
    it "returns the first entry's price" do
      expect(subject.price).to eq(Money.new(2))
    end

    it "returns nil if entry's price is nil" do
      prices.stub(:last) { nil }
      expect(subject.price).to eq 0
    end
  end

  describe "#price_for_installments" do
    it "returns the first entry's price" do
      expect(subject.price_for_installments).to eq Money.new(4)
    end

    it "returns nil if entry's price is nil" do
      prices.stub(:last) { nil }
      expect(subject.price).to eq 0
    end
  end
end
