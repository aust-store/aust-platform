require "spec_helper"

describe OrderItem do
  describe "callbacks" do
    describe "#set_status_as_pending on before_validation" do
      it "sets the status field to pending" do
        item = FactoryGirl.build(:order_item_without_associations)
        item.valid?
        expect(item.status).to eq "pending"
      end
    end

    describe "#set_quantity_to_one on before_validation" do
      it "sets the quantity to 1 if it's nil" do
        item = FactoryGirl.build(:order_item_without_associations, quantity: 0)
        item.valid?
        expect(item.quantity).to eq 1
      end

      it "doesn't change the quantity if it's present" do
        item = FactoryGirl.build(:order_item_without_associations, quantity: 3)
        item.valid?
        expect(item.quantity).to eq 3
      end
    end
  end

  describe "validations" do
    describe "status" do
      let(:order) { FactoryGirl.build(:order_item_without_associations) }

      specify "the valid values" do
        order.status = "pending"
        expect(order).to be_valid
        order.status = "shipped"
        expect(order).to be_valid
        order.status = "cancelled"
        expect(order).to be_valid
      end

      specify "the invalid values" do
        order.status = "whatever"
        expect(order).to be_invalid
        order.status = "canceled"
        expect(order).to be_invalid
      end
    end
  end

  describe "#remaining_entries_in_stock" do
    it "returns the quantity still in stock" do
      item = OrderItem.new
      item.stub_chain(:inventory_entry, :quantity) { 10 }
      item.remaining_entries_in_stock.should == 10
    end
  end

  describe "#quantity" do
    it "returns a integer" do
      item = OrderItem.new(quantity: 2)
      expect(item.quantity).to equal(2)
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
