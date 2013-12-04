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

      it "unsets other cover images if the current one is cover" do
        another_item  = FactoryGirl.create(:inventory_item)
        another_image = FactoryGirl.create(:inventory_item_image,
                                           inventory_item: another_item,
                                           cover: true)
        another_item.save

        item = FactoryGirl.create(:inventory_item)
        item.images << InventoryItemImage.new
        item.images << InventoryItemImage.new(cover: true)
        item.save

        images = item.images.order(:id)
        images.first.should_not be_cover
        images.last.should be_cover

        another_image.reload.should be_cover
      end
    end

    describe "#guarantee_cover_after_delete" do
      it "sets the next image as cover if cover is deleted" do
        item = FactoryGirl.create(:inventory_item)
        item.images << InventoryItemImage.new
        item.images << InventoryItemImage.new
        item.save
        images = item.images.order(:id)
        images.first.cover.should == true
        images.last .cover.should == false

        images.first.destroy
        images.to_a.last.cover.should == true
      end
    end
  end

  describe ".has_cover" do
    it "returns true if at least one cover image exists" do
      FactoryGirl.create(:inventory_item_cover_image)
      expect(InventoryItemImage).to have_cover
    end

    it "returns true even when defining it to false" do
      FactoryGirl.create(:inventory_item_image).update_attributes(cover: false)
      expect(InventoryItemImage).to have_cover
    end
  end
end
