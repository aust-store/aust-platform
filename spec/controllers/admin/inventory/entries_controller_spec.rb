require "spec_helper"

describe Admin::Inventory::EntriesController do
  login_admin

  it_obeys_the "admin application controller contract"

  let(:items) { double }

  before do
    Store::Currency.stub(:to_float).with("R$ 20.0").and_return(20.0)

    item = double(balances: items)
    controller.stub_chain(:current_company, :items, :find) { item }
  end

  describe "GET index" do
    it "loads good's entries" do
      Admin::InventoryEntryDecorator.stub(:decorate).with(items) { :items }
      get :index, good_id: 1
      assigns(:entries).should == :items
    end
  end

  describe "GET new" do
    it "builds a new balance" do
      items.stub(:build).and_return(:item)
      controller.stub(:load_entries_summary)
      Admin::InventoryEntryDecorator.stub(:decorate).with(:item) { :item }
      get :new, good_id: 1
      assigns(:entry).should == :item
    end

    it "loads entries summary" do
      items.stub(:build).and_return(:items)
      items.stub(:order).with("id desc") { items }
      items.stub(:last).with(6) { :items }
      Admin::InventoryEntryDecorator.stub(:decorate).with(:items) { :item }
      get :new, good_id: 1
      assigns(:last_entries).should == :item
    end
  end

  describe "POST create" do
    before do
      items.stub(:build).and_return(items)
      items.stub(:balance_type=)
      items.stub(:store_id=)

      controller.current_company.stub(:id) { 1 }
    end

    it "redirects if saving balance successfully" do
      items.stub(:good) { :good }
      items.stub(:save) { true }

      items.should_receive(:store_id=).with(1)
      items.should_receive(:balance_type=).with("in")

      controller.stub(:load_entries_summary)
      post :create, good_id: 1, inventory_entry: { cost_per_unit: "R$ 20.0" }
      response.should redirect_to admin_inventory_good_entries_url(:good)
    end

    it "render form if not saving entry successfully" do
      items.stub(:save) { false }
      controller.stub(:load_entries_summary)
      post :create, good_id: 1, inventory_entry: { cost_per_unit: "R$ 20.0" }
      response.should render_template "new"
      assigns(:entry).should == items
    end

    it "loads entries summary" do
      items.stub(:save) { false }
      items.stub(:order).with("id desc") { items }
      items.stub(:last).with(6) { :items }
      Admin::InventoryEntryDecorator.stub(:decorate) { :item }
      post :create, good_id: 1, inventory_entry: { cost_per_unit: "R$ 20.0" }
      assigns(:last_entries).should == :item
    end
  end
end
