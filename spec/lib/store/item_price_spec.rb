require "contracts/lib/store/item_price_contract"
require "store/item_price"

describe Store::ItemPrice do
  it_behaves_like "item price contract"

  let(:item) { double }

  subject { Store::ItemPrice.new(item) }

  describe "#price" do
    it "returns the first entry's price" do
      subject.stub(:entry_for_sale) { double(price: 10) }
      expect(subject.price).to eql(10)
    end

    it "returns nil if entry's price is nil" do
      subject.stub(:entry_for_sale) { double(price: nil) }
      expect(subject.price).to be_nil
    end

    it "returns nil if no entry is defined" do
      subject.stub(:entry_for_sale) { nil }
      expect(subject.price).to be_nil
    end
  end

  describe "#entry_for_sale" do
    it "returns the item's first inventory entry" do
      item.stub(:entry_for_sale) { :first }
      expect(subject.entry_for_sale).to eql(:first)
    end
  end
end
