require "spec_helper"

describe Admin::Inventory::EntriesController do
  login_admin

  # TODO fix contracts
  it_obeys_the "admin application controller contract"
  #it_obeys_the "Good model contract"

  let(:items) { double }

  before do
    Store::Currency.stub(:to_float).with("R$ 20.0").and_return(20.0)

    good = double(balances: items)
    controller.stub_chain(:current_company, :items, :find) { good }
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
      items.stub(:build).and_return(:items)
      get :new, good_id: 1
      assigns(:entry).should == :items
    end
  end

  describe "POST create" do
    before do
      items.stub(:build).and_return(items)
      items.stub(:balance_type=)
    end

    it "redirects if saving balance successfully" do
      items.stub(:good) { :good }
      items.stub(:save) { true }

      post :create, good_id: 1, inventory_entry: { cost_per_unit: "R$ 20.0" }
      response.should redirect_to admin_inventory_good_entries_url(:good)
    end

    it "render form if not saving entry successfully" do
      items.stub(:save) { false }
      post :create, good_id: 1, inventory_entry: { cost_per_unit: "R$ 20.0" }
      response.should render_template "new"
      assigns(:entry).should == items
    end
  end
end
