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

  describe ".has_cover" do
    before do
      InventoryItemImage.any_instance.stub(:inventory_item) { double(images: [1]) }
    end

    it "returns true if at least one cover image exists" do
      FactoryGirl.create(:inventory_item_cover_image)
      expect(InventoryItemImage).to have_cover
    end

    it "returns true if at least one cover image exists" do
      FactoryGirl.create(:inventory_item_image)
      expect(InventoryItemImage).to_not have_cover
    end
  end
end
