require 'spec_helper'

describe Admin::Goods::BalancesController do
  login_admin

  describe "POST /create" do
    def valid_attributes
      { "description"   => "These came from Japan.",
        "quantity"      => "4",
        "cost_per_unit" => "20.0" }
    end

    before do
      @good = Factory(:good)
    end

    describe "saving balance" do
      before do
        post :create, { good_id: @good.id, good_balance: valid_attributes }
      end

      subject { Good::Balance.first }

      its(:description)     { should == "These came from Japan." }
      its(:quantity)        { should == 4 }
      its(:cost_per_unit)   { should == 20.0 }
      its(:balance_type)    { should == "in" }
      its(:moving_average_cost) { should == 20.0 }
      its(:total_quantity)  { should == 4 }
      its(:total_cost)      { should == 80.0 }
    end
  end
end
