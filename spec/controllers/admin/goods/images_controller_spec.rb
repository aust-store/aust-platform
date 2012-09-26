require "spec_helper"

describe Admin::Goods::ImagesController do
  login_admin

  # TODO fix contracts
  #it_obeys_the "Good model extension contract"
  #it_obeys_the "application controller contract"

  describe "GET index" do
    it "should find the respective good and build its image" do
      Good.should_receive(:find_and_build_image).with("12") { :good }
      get :index, good_id: 12
      assigns(:good).should == :good
    end
  end
end
