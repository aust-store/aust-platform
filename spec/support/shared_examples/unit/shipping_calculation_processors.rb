shared_examples "shipping processor" do
  context "standard operation of a processor" do
    let(:item)     { double(length: 1, width: 2, height: 3, weight: 4) }
    let(:options) do
      { source_zipcode:      "123",
        destination_zipcode: "456",
        items:               items,
        shipping_type:       :normal }
    end

    subject { described_class.new(options) }

    it "responds to standard processor interface" do
      expect { subject.calculate }.to_not raise_error NoMethodError
    end
  end
end
