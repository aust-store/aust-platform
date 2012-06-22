# TODO unit test
require "spec_helper"

describe Admin::GoodBalanceDecorator do
  def attributes
    { cost_per_unit: "10.0", total_cost: "14.14",
      created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @balance = stub attributes
    @presenter = Admin::GoodBalanceDecorator.new @balance
  end

  describe ".cost_per_unit" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 10,00"
      @presenter.cost_per_unit.should == "R$ 10,00"
    end
  end

  describe ".total_cost" do
    it "should return converted to R$" do
      @presenter.should_receive(:to_currency).and_return "R$ 14,14"
      @presenter.total_cost.should == "R$ 14,14"
    end
  end

  describe ".cost_per_unit" do
    it "should return a float converted to R$" do
      @presenter.created_at.should == "14/04/2012"
    end
  end
end
