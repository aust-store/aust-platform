require "unit_spec_helper"
require "store/domain_object/balance"
require "ostruct"
require "bigdecimal"

describe Store::DomainObject::Balance do

  before do
    @balances = [
      OpenStruct.new(quantity: 10.0, cost_per_unit: 20.0), # 200
      OpenStruct.new(quantity: 12.0, cost_per_unit: 25.0), # 300
      OpenStruct.new(quantity: 7.0, cost_per_unit: 28.0)   # 196
    ]
  end

  subject { Store::DomainObject::Balance.new(@balances) }

  describe "#calculate" do
    it "returns a hash with balance status" do
      #subject.calculate()
    end
  end

  describe "#moving_average_cost" do
    it "should return 24" do
      subject.moving_average_cost.to_s.should == BigDecimal("24.0").to_s
    end

    context "when no balance is given" do
      it "should return zero" do
        Store::DomainObject::Balance.new([]).moving_average_cost.to_s.should == BigDecimal("0.0").to_s
      end
    end
  end

  describe "#total_quantity" do
    it "should return 29" do
      subject.total_quantity.to_s.should == BigDecimal("29.0").to_s
    end

    context "when no balance is given" do
      it "should return zero" do
        Store::DomainObject::Balance.new([]).total_quantity.to_s.should == BigDecimal("0").to_s
      end
    end
  end

  describe "#total_cost" do
    it "should return 696" do
      subject.total_cost.to_s.should == BigDecimal("696.0").to_s
    end

    context "when no balance is given" do
      it "should return zero" do
        Store::DomainObject::Balance.new([]).total_cost.to_s.should == BigDecimal("0").to_s
      end
    end
  end
end
