require "spec_helper"

describe OrderItem do
  describe "#remaining_entries_in_stock" do
    it "returns the quantity still in stock" do
      item = OrderItem.new
      item.stub_chain(:inventory_entry, :quantity) { 10 }
      item.remaining_entries_in_stock.should == 10
    end
  end

  describe "#update_quantity" do
    let(:item) { OrderItem.new }

    before do
      item.stub_chain(:inventory_entry, :quantity) { 5 }
    end

    it "updates the quantity" do
      item.should_receive(:update_attributes).with(quantity: 3)
      item.update_quantity(3)
    end

    it "updates the quantity to zero if negative number is given" do
      item.should_receive(:update_attributes).with(quantity: 0)
      item.update_quantity(-1)
    end

    it "limits the available quantity to the same quantity in the inventory" do
      item.should_receive(:update_attributes).with(quantity: 5)
      item.update_quantity(10)
    end
  end
end
