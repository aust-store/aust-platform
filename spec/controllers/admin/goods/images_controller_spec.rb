require "spec_helper"

describe Admin::Goods::ImagesController do
  login_admin

  describe "GET index" do
    let(:good) { double }
    let(:items) { double }

    it "should find the respective good and build its image" do
      controller.current_company.stub(:items) { items }

      good.stub_chain(:images, :order, :dup) { :images }
      good.stub_chain(:images, :build)
      items.should_receive(:find).with("12") { good }

      get :index, good_id: 12
      assigns(:good).should == good
      assigns(:item_images).should == :images
    end
  end

  describe "DELETE destroy" do
    let(:items) { double }
    let(:item) { double }
    let(:images) { double }
    let(:image) { double }

    it "deletes an image" do
      controller.current_company.stub(:items) { items }
      items.should_receive(:find).with("1") { item }

      item.stub(:images) { images }
      images.should_receive(:find).with("12") { image }
      image.should_receive(:destroy)

      delete :destroy, good_id: 1, id: 12
    end

    it "redirects to the images index" do
      controller.current_company.stub_chain(:items, :find) { item }
      item.stub_chain(:images, :find, :destroy)

      delete :destroy, good_id: 1, id: 12
      response.should redirect_to admin_inventory_good_images_path(1)
    end
  end
end
