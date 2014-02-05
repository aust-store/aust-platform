require "store/item_price"

shared_examples "item price contract" do
  describe "ItemPrice" do
    subject { Store::ItemPrice.new(double) }

    it "responds to price" do
      expect(subject).to respond_to(:price)
    end

    it "responds to price_for_installments" do
      expect(subject).to respond_to(:price_for_installments)
    end
  end
end
