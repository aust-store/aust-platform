require "spec_helper"

describe Admin::InventoryEntryDecorator do
  def attributes
    { cost_per_unit: "10.0", total_cost: "14.14",
      created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @entry = stub attributes
    @presenter = Admin::InventoryEntryDecorator.new @entry

    @inventory_entry = double.as_null_object
    @presenter.stub(:inventory_entry) { @inventory_entry }
  end

  describe "#cost_per_unit" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 10,00"
      @presenter.cost_per_unit.should == "R$ 10,00"
    end
  end

  describe "#quantity" do
    it "should return an integer" do
      @presenter.stub_chain(:inventory_entry, :quantity).and_return 12.0
      @presenter.quantity.should == 12
    end
  end

  describe "#price" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 14,14"
      @presenter.price.should == "R$ 14,14"
    end
  end

  describe "#total_cost" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 14,14"
      @presenter.total_cost.should == "R$ 14,14"
    end
  end

  describe "#created_at" do
    it "should the date in the 14/04/2012 format" do
      @inventory_entry.stub(:created_at) { attributes[:created_at] }
      @presenter.created_at.should == "14/04/2012"
    end
  end
end
