module Store; class Currency; end; end
require "unit_spec_helper"
require "controllers/admin/inventory/entries_controller"

describe Admin::Inventory::EntriesController do

  it_obeys_the "application controller contract"
  it_obeys_the "Good model contract"

  let(:valid_attributes) do
    { "description"   => "These came from Japan.",
      "quantity"      => "4",
      "cost_per_unit" => "R$ 20.0" }
  end
  let(:sanitized_attributes) do
    { "description"   => "These came from Japan.",
      "quantity"      => "4",
      "cost_per_unit" => 20.0 }
  end

  before do
    @good = double
    @balances = double
    @balances.stub(:good).and_return(@good)
    @balances.stub(:balance_type=)
    subject.stub_chain(:current_user, :company) { 1 }

    Store::Currency.stub(:to_float).with("R$ 20.0").and_return(20.0)

    Good.stub_chain(:where, :within_company, :first).and_return(@good)
  end

  it "should raise if other company's id was given" do
    Good.stub_chain(:where, :within_company, :first).and_return(nil)
    expect do
      get :index, good_id: invalid_good.id
    end.to raise_error
  end

  describe "#index" do
    it "loads good's entries" do
      @good.stub(:balances) { double(balances: @balances) }
      Admin::InventoryEntryDecorator.stub(:decorate) { @balances }
      subject.index.should == @balances
    end
  end

  describe "#new" do
    it "builds a new balance" do
      @good.stub_chain(:balances, :build).and_return(@balances)
      subject.new.should == @balances
    end
  end

  describe "#create" do
    before do
      @good.stub_chain(:balances, :build).with(sanitized_attributes) { @balances }
      subject.stub(:params) do
        { inventory_entry: sanitized_attributes }
      end
    end

    it "redirects if saving balance successfully" do
      @balances.stub(:save) { true }
      subject.stub(:admin_inventory_good_entries_url).with(@good) { "good"}
      subject.should_receive(:redirect_to).with("good")
      subject.create
    end

    it "renderform if not saving entry successfully" do
      @balances.stub(:save) { false }
      subject.should_receive(:render).with("new")
      subject.create
    end
  end

  describe "#update" do
    before do
      @good.stub_chain(:balances, :find).with("1").and_return(@balances)
      subject.stub(:params) do
        { id: "1", inventory_entry: sanitized_attributes }
      end
    end

    it "redirects if updating the entry successfully" do
      @balances.stub(:update_attributes).with(sanitized_attributes) { true }
      subject.stub(:admin_inventory_good_entries_url).with(@good) { "good"}
      subject.should_receive(:redirect_to).with("good")
      subject.update
    end

    it "renders form if not updating entry successfully" do
      @balances.stub(:update_attributes).with(sanitized_attributes) { false }
      subject.should_receive(:render).with("edit")
      subject.update
    end
  end
end
