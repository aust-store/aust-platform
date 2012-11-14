require 'spec_helper'

describe Admin::Inventory::ItemsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "#index" do
    it "assigns all items as @items" do
      subject.stub_chain(:current_company, :items, :all) { 123 }
      get :index
      assigns(:items).should == 123
    end
  end

  describe "#show" do
    let(:item) { double }

    it "should return a single item" do
      item.stub_chain(:images, :order, :limit, :dup) { :images }
      subject.stub_chain(:current_company, :items, :find).with("123") { item }
      DecorationBuilder.should_receive(:inventory_items).with(item) { :decorated_item }

      item.stub(:all_entries_available_for_sale)
      get :show, id: 123
      assigns(:item).should == :decorated_item
      assigns(:item_images).should == :images
    end
  end

  describe "#new" do
    let(:item) { double.as_null_object }

    before do
      InventoryItem.stub(:new) { item }
    end

    it "should instantiate a item" do
      get :new
      assigns(:item).should == item
    end

    it "builds a shipping box instance" do
      item.should_receive(:build_shipping_box)
      get :new
    end
  end

  describe "#edit" do
    let(:items) { double }

    before do
      controller.should_receive(:load_item)
    end

    it "should instantiate a given item" do
      DecorationBuilder.stub(:inventory_items).with(:item) { :item }
      subject.stub_chain(:current_company, :items, :includes) { items }
      items.stub(:find).with("1") { :item }
      get :edit, id: 1
      assigns(:item).should == :item
    end
  end

  describe "#create" do
    let(:item_creation) { double }

    before do
      Store::InventoryItemCreation.stub(:new) { item_creation }
    end

    it "creates a new inventory item" do
      item_creation.should_receive(:create).with("item") { true }
      post :create, inventory_item: :item
    end

    it "redirect to the inventory when the item is created" do
      item_creation.stub(:create) { true }
      post :create, inventory_item: :item
      response.should redirect_to admin_inventory_items_url
    end

    it "renders the form again when no item was created" do
      item_creation.stub(:create) { false }
      item_creation.stub(:active_record_item) { :active_record_item }
      post :create, inventory_item: :item
      response.should render_template "new"
      assigns(:item).should == :active_record_item
    end
  end
end
