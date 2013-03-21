require "spec_helper"

describe OrderItem do
  before do
    @order = FactoryGirl.create(:order)
    @item = @order.items.parent_items.first
    @item.stub_chain(:inventory_entry, :quantity) { 10 }
  end

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

    it "returns a the sum of children count + 1(parent)" do
      @item.update_quantity(5)

      @item.quantity.should == 5
      @item.children.count.should == 4
    end
  end

  describe "#sanitize_quantity" do
    it "returns 0 if the given quantity is inferior to zero" do
      @item.sanitize_quantity(-1).should == 0
    end

    it "returns remaining entries in stock if the given quantity is higher than that" do
      # There's 10 remaining entries in stock already stubbed before.
      @item.sanitize_quantity(11).should == 10
    end
  end

  describe "#update_quantity" do
    context "given a higher quantity than an existent" do
      it "creates children with the same attributes of an existing order item" do
        @item.price = 12
        @item.save

        @item.update_quantity(3)

        # There's another 12 different order items already created by order factory.
        @item.children.count.should == 2
        @order.items  .count.should == 15

        changed_items = @order.items.where(parent_id: !nil)
        changed_items.each do |item|
          item.price.to_s.should == "12.0"
        end
      end

      it "limits the number of children to the same quantity in the inventory, parent is included in the calculation" do
        # There's 10 remaining entries in stock already stubbed before.
        @item.update_quantity(15)

        # There's another 12 different order items already created by order factory.
        @order.items  .count.should == 22
        @item.children.count.should == 9
      end

      it "the order item's quantity should be the equal the sum of it's children + 1" do
        @item.update_quantity(10)

        @item.quantity.should == 10
        @item.children.count.should == 9
      end

      it "doesn't creates or destroys any children when the given quantity is equal to the current" do
        @item.quantity.should == 4
        @item.children.count.should == 3

        @item.update_quantity(4)

        @item.quantity.should == 4
        @item.children.count.should == 3
      end
    end

    context "given a lower number than an existent, including zero" do
      it "destroys last created children when quantity is less than a existent quantity given before" do
        # The current quantity for each item is 4 (1 parent, 3 chidren).
        @order.items.count.should == 16

        # One children shall be reduced (1 parent, 2 children).
        @item.update_quantity(3)
        @item.children.count.should == 2

        # Only the parent item should remain (1 parent, 0 children).
        @item.update_quantity(1)
        @item.children.count.should == 0
        @order.items.count.should == 13
      end

      it "destroys all order item's children and sets its quantity to zero when the quantity is zero" do
        @order.items.count.should == 16

        # Only parent item should remains with its quantity zero.
        @item.update_quantity(0)

        @item.quantity.should == 0
        @item.children.count.should == 0
        @order.items.count.should == 13
      end
    end
  end
end