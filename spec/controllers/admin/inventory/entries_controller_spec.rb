require "spec_helper"

describe Admin::Inventory::EntriesController do
  login_admin

  it_obeys_the "admin application controller contract"

  let(:items) { double }

  before do
    Store::Currency.stub(:to_float).with("12.34").and_return(20.0)

    item = double(balances: items)
    controller.stub_chain(:current_company, :items, :friendly, :find) { item }
  end

  describe "GET index" do
    it "loads item's entries" do
      Admin::InventoryEntryDecorator.stub(:decorate_collection).with(items) { :items }
      get :index, item_id: 1
      assigns(:entries).should == :items
    end
  end

  describe "GET new" do
    it "builds a new balance" do
      items.stub(:build).and_return(:item)
      controller.stub(:load_entries_summary)
      Admin::InventoryEntryDecorator.stub(:decorate).with(:item) { :item }
      get :new, item_id: 1
      assigns(:entry).should == :item
    end

    it "loads entries summary" do
      items.stub(:build).and_return(:items)
      items.stub(:order).with("id desc") { items }
      items.stub(:last).with(6) { :items }
      Admin::InventoryEntryDecorator.stub(:decorate).with(:items) { :item }
      get :new, item_id: 1
      assigns(:last_entries).should == :item
    end
  end

  describe "POST create" do
    before do
      items.stub(:build).and_return(items)
      items.stub(:store_id=)
      items.stub(:admin_user_id=)

      controller.current_company.stub(:id) { 1 }
      controller.current_user.stub(:id) { 1 }
    end

    it "redirects if saving balance successfully" do
      items.stub(:inventory_item) { :item }
      items.stub(:save) { true }

      items.should_receive(:store_id=).with(1)
      items.should_receive(:admin_user_id=).with(1)

      controller.stub(:load_entries_summary)
      post :create, item_id: 1, inventory_entry: { cost_per_unit: "12.34" }
      response.should redirect_to admin_inventory_item_entries_url(:item)
    end

    it "render form if not saving entry successfully" do
      items.stub(:save) { false }
      controller.stub(:load_entries_summary)
      post :create, item_id: 1, inventory_entry: { cost_per_unit: "12.34" }
      response.should render_template "new"
      assigns(:entry).should == items
    end

    it "loads entries summary" do
      items.stub(:save) { false }
      items.stub(:order).with("id desc") { items }
      items.stub(:last).with(6) { :items }
      Admin::InventoryEntryDecorator.stub(:decorate) { :item }
      post :create, item_id: 1, inventory_entry: { cost_per_unit: "12.34" }
      assigns(:last_entries).should == :item
    end
  end

  describe "PUT update" do
    let(:entry) { double }

    before do
      @item = FactoryGirl.create(:inventory_item, company: @company)
      controller.stub_chain(:current_company, :items, :friendly, :find) { @item }
    end

    it "updates an inventory entry" do
      @item.stub_chain(:balances, :find) { entry }
      entry.should_receive(:update_attributes).with("on_sale" => "0")
      controller.stub(:render)
      put :update, item_id: 1, id: 2,
        inventory_entry: { on_sale: "0" }, format: "js"
    end

    describe "redirections" do
      it "updates an inventory entry" do
        entry.stub(:update_attributes) { true }
        first_entry = InventoryEntry.first
        put :update, item_id: @item.id, id: first_entry.id, inventory_entry: { on_sale: "0" }, format: "js"
        ActiveSupport::JSON.decode(response.body).should == {
          "inventory_item" => {
            "id"                => @item.id,
            "name"              => @item.name,
            "description"       => "Lorem ipsum lorem",
            "price"             => "20.0",
            "entry_for_sale_id" => @item.entry_for_sale.id,
            "on_sale"           => true
          }
        }
      end

      it "updates an inventory entry" do
        entry.stub(:update_attributes) { false }
        first_entry = InventoryEntry.first
        put :update, item_id: @item.id, id: first_entry.id, inventory_entry: { on_sale: "0" }, format: "js"
        ActiveSupport::JSON.decode(response.body).should == {
          "inventory_item" => {
            "id"                => @item.id,
            "name"              => @item.name,
            "description"       => "Lorem ipsum lorem",
            "price"             => "20.0",
            "entry_for_sale_id" => @item.entry_for_sale.id,
            "on_sale"           => true
          }
        }
      end
    end
  end
end
