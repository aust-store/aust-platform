require "spec_helper"

describe Admin::Goods::ImagesController do
  login_admin

  # TODO fix contracts
  #it_obeys_the "Good model extension contract"
  #it_obeys_the "application controller contract"

  describe "GET index" do
    let(:good) { double }
    let(:items) { double }

    it "should find the respective good and build its image" do
      controller.current_company.stub(:items) { items }

      good.stub_chain(:images, :dup) { :images }
      good.stub_chain(:images, :build)
      items.should_receive(:find).with("12") { good }

      get :index, good_id: 12
      assigns(:good).should == good
      assigns(:item_images).should == :images
    end
  end
end
