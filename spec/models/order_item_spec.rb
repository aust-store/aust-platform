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

  describe "#quantity" do
    before do
      @order = FactoryGirl.create(:order)
      @item = @order.items.parent_items.first
    end

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

  describe "#update_quantity" do
    context "when it's meant to increase the quantity" do
      before do
        @order = FactoryGirl.create(:order, total_items: 1)
        @item = @order.items.first
      end

      it "creates children with the same attributes" do
        @item.inventory_entry.update_attributes(quantity: 3)
        @item.price = 12.0
        @item.save
        @item.update_quantity(30)

        # There are other 2 different existing order items
        @item.children.count.should == 2
        @order.items  .count.should == 3
        @item.quantity.should       == 3

        prices = @order.items.all.map { |i| i.price.to_s }
        prices.all? { |price| price == "12.0" }.should be_true
      end
    end

    context "given a lower number than an existent, including zero" do
      before do
        @order = FactoryGirl.create(:order, total_items: 5)
        @item = @order.items.parent_items.first
      end

      it "destroys last created children when quantity is less than a existent quantity given before" do
        @order.items.count.should == 5
        @item.quantity.should     == 5

        @item.update_quantity(3)
        @item.children.count.should == 2
        @item.quantity.should       == 3
        @order.items.count.should   == 3

        @item.update_quantity(1)
        @item.children.count.should == 0
        @item.quantity.should       == 1
        @order.items.count.should   == 1
      end

      it "sets quantity to zero without destroying the parent item" do
        @item.update_quantity(0)

        @item.quantity.should       == 0
        @item.children.count.should == 0
        @order.items.count.should   == 1
      end
    end
  end
end
