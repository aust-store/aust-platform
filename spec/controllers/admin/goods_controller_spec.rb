require 'spec_helper'

describe Admin::GoodsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "#index" do
    it "assigns all goods as @goods" do
      subject.stub_chain(:current_company, :items, :all) { 123 }
      get :index
      assigns(:goods).should == 123
    end
  end

  describe "#show" do
    let(:good) { double }

    it "should return a single good" do
      good.stub_chain(:images, :order, :limit, :dup) { :images }
      subject.stub_chain(:current_company, :items, :find).with("123") { good }
      DecorationBuilder.should_receive(:good).with(good) { :decorated_good }

      good.stub(:all_entries_available_for_sale)
      get :show, id: 123
      assigns(:good).should == :decorated_good
      assigns(:item_images).should == :images
    end
  end

  describe "#new" do
    it "should instantiate a good" do
      Good.stub(:new) { :good }
      get :new
      assigns(:good).should == :good
    end
  end

  describe "#edit" do
    it "should instantiate a given good" do
      subject.stub_chain(:current_company, :items, :find).with("1") { :good }
      get :edit, id: 1
      assigns(:good).should == :good
    end
  end

  describe "#create" do
    let(:item_creation) { double }

    before do
      Store::InventoryItemCreation.stub(:new) { item_creation }
    end

    it "creates a new inventory item" do
      item_creation.should_receive(:create).with("good") { true }
      post :create, good: :good
    end

    it "redirect to the inventory when the item is created" do
      item_creation.stub(:create) { true }
      post :create, good: :good
      response.should redirect_to admin_inventory_goods_url
    end

    it "renders the form again when no item was created" do
      item_creation.stub(:create) { false }
      item_creation.stub(:active_record_item) { :active_record_item }
      post :create, good: :good
      response.should render_template "new"
      assigns(:good).should == :active_record_item
    end
  end
end
