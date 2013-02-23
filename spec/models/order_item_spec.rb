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

  describe "#update_quantity", wip: true do
    let(:item) { OrderItem.new }

    before do
      item.stub_chain(:inventory_entry, :quantity) { 5 }
    end

    it "clones an existing order item with the same attributes" do
      order = FactoryGirl.create(:order)
      item  = order.items.first
      item.price = 12
      item.save

      item.update_quantity(3)

      # There's 4 diferent order items already created by order factory.
      item.children.count.should == 2
      order.items.count.should   == 6

      last_items = order.items.first(3)
      last_items.each do |item|
        item.price.to_s.should == "12.0"
      end
    end

    it "destroys all order_items when quantity is zero" do
      order = FactoryGirl.create(:order)
      item  = order.items.first

      item.update_quantity(0)

      # There's 4 diferent order items already created by order factory.
      order.items.count.should == 3

    end

    it "destroys last created children when quantity is less than a existent quantity given before" do
      order = FactoryGirl.create(:order)
      item  = order.items.first
      item.inventory_entry.update_attribute(:quantity, 10)

      order.items.count.should   == 4
      item.update_quantity(4)
      item.children.count.should == 3
      order.items.count.should   == 7

      # There's 4 diferent order items already created by order factory.
      item.update_quantity(0)
      item.children.count.should == 0
      order.items.count.should   == 3

      item.update_quantity(1)
      item.children.count.should == 0
      order.items.count.should   == 4
    end

    it "limits the number of clones to the same quantity in the inventory" do
      order = FactoryGirl.create(:order)
      item  = order.items.first

      item.inventory_entry.update_attribute(:quantity, 5)

      item.update_quantity(15)
      order.items.count.should == 8
    end
  end
end