require "decoration_builder"

describe DecorationBuilder do
  before do
    stub_const("Admin::InventoryItemDecorator", Object.new)
  end

  describe ".item" do
    it "returns a decorated InventoryItem" do
      item = double
      Admin::InventoryItemDecorator.stub(:decorate)
                          .with(item) { :item }
      DecorationBuilder.inventory_items(item).should == :item
    end
  end
end
