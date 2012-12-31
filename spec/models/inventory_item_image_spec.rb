require "spec_helper"

describe InventoryItemImage do
  describe "callbacks" do
    describe "#set_as_cover_if_first" do
      it "sets the first image as cover" do
        item = FactoryGirl.create(:inventory_item)
        item.images << InventoryItemImage.new
        item.images << InventoryItemImage.new
        item.save
        images = item.images.order(:id)
        images.first.cover.should == true
        images.last .cover.should == false
      end
    end
  end
end
