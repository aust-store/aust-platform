require "unit_spec_helper"

class Good; class Balance; end; end
require "decorators/admin/good_balance_decorator"

describe Admin::GoodBalanceDecorator do

  it_obeys_the "admin good balance decorator contract"

  def attributes
    { cost_per_unit: "10.0", total_cost: "14.14",
      created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @balance = stub attributes
    @presenter = Admin::GoodBalanceDecorator.new @balance

    @good_balance = double.as_null_object
    @presenter.stub(:good_balance) { @good_balance }
  end

  describe "#cost_per_unit" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 10,00"
      @presenter.cost_per_unit.should == "R$ 10,00"
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
      @good_balance.stub(:created_at) { attributes[:created_at] }
      @presenter.created_at.should == "14/04/2012"
    end
  end
end
