require 'spec_helper'

describe Admin::Inventory::ItemsController do
  login_admin

  let(:company) { double }
  let(:item) { double(shipping_box: :shipping_box) }

  before do
    subject.stub(:current_company) { company }
    company.stub_chain(:taxonomies, :flat_hash_tree) { double }
    company.stub_chain(:suppliers, :to_a) do
      [ double(id: 1, first_name: "Coke"),
        double(id: 2, first_name: "Pepsi") ]
    end

    Store::InventoryItem::Deletable.stub(:new).with(item) { double(valid?: true) }
  end

  describe "GET index" do
    let(:items) { double }

    before do
      subject.stub_chain(:current_company, :items) { items }
    end

    it "assigns all items as @items" do
      items.stub_chain(:includes, :order, :page) { 123 }
      items.stub(:last) { 1234 }
      get :index
      assigns(:items).should == 123
      assigns(:last_addition).should == 1234
    end
  end

  describe "#show" do
    let(:taxonomy) { double(self_and_ancestors: [1, 2, 3]) }

    before do
      subject.stub_chain(:current_company, :items, :friendly, :find) { item }
      Store::Policy::ItemOnSale.stub_chain(:new, :on_sale?) { :on_sale }
      Store::OnlineSales::ReasonForItemNotOnSale.any_instance.stub(:reasons)
      item.stub(:taxonomy) { taxonomy }
      item.stub_chain(:images, :default_order, :limit, :dup) { :images }
      item.stub(:all_entries_elligible_for_sale)
    end

    it "should return a single item" do
      DecorationBuilder.should_receive(:inventory_items).with(item) { :decorated_item }
      DecorationBuilder.should_receive(:shipping_box).with(item.shipping_box)

      get :show, id: 123
      assigns(:item).should == :decorated_item
      assigns(:item_images).should == :images
    end

    it "instantiates the item's taxonomy" do
      get :show, id: 123
      assigns(:taxonomy).should == [3, 2, 1]
    end

    it "assigns deletable item" do
      get :show, id: 123
      assigns(:deletable).should be_true
    end
  end

  describe "#new" do
    let(:item) { double.as_null_object }

    before do
      InventoryItem.stub(:new) { item }
      company.stub_chain(:items, :new) { item }
      company.stub_chain(:custom_fields, :where) { item }
    end

    it "should instantiate an item" do
      get :new
      assigns(:item).should == item
    end

    it "builds a shipping box instance" do
      item.should_receive(:build_shipping_box)
      get :new
    end
  end
end
