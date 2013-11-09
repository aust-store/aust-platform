require "spec_helper"

describe Admin::Inventory::Items::ImagesController do
  login_admin

  describe "GET index" do
    let(:item) { double }
    let(:items) { double }

    it "should find the respective item and build its image" do
      controller.current_company.stub(:items) { items }

      item.stub_chain(:images, :order, :dup) { :images }
      item.stub_chain(:images, :build)
      items.stub_chain(:friendly, :find).with("12") { item }

      get :index, item_id: 12
      assigns(:item).should == item
      assigns(:item_images).should == :images
    end
  end

  describe "DELETE destroy" do
    let(:items)  { double }
    let(:item)   { double }
    let(:images) { double }
    let(:image)  { double }

    it "deletes an image" do
      controller.current_company.stub(:items) { items }
      items.stub_chain(:friendly, :find).with("1") { item }

      item.stub(:images) { images }
      images.should_receive(:find).with("12") { image }
      image.should_receive(:destroy)

      delete :destroy, item_id: 1, id: 12
    end

    it "redirects to the images index" do
      controller.current_company.stub_chain(:items, :friendly, :find) { item }
      item.stub_chain(:images, :find, :destroy)

      delete :destroy, item_id: 1, id: 12
      response.should redirect_to admin_inventory_item_images_path(1)
    end
  end

  describe "PUT update" do
    let(:item) { double(images: images) }
    let(:images) { double(find: image) }
    let(:image) { double }

    it "updates the image cover attribute" do
      controller.current_company.stub_chain(:items, :friendly, :find) { item }
      images.should_receive(:update_all).with(cover: false)
      image.should_receive(:update_attributes).with(cover: true)
      put :update, item_id: 1, id: 2, set_cover: true
    end

    it "redirects to the image management page" do
      put :update, item_id: 1, id: 2, set_cover: false
      response.should redirect_to admin_inventory_item_images_path
    end
  end
end
