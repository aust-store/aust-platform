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
      @good = Factory(:good, company_id: @admin_user.company_id)
    end

    it "shold load the correct good" do
      invalid_good = Factory(:good, company_id: Factory(:company).id)
      expect { get :index, good_id: invalid_good.id }.to raise_error
    end

    describe "GET index" do
      it "loads good's balances" do
        get :index, good_id: @good.id
        assigns(:good).should == @good
      end
    end

    describe "GET new" do
      it "builds a new balance" do
        get :new, good_id: @good.id
        assigns(:balance).should be_a_new Good::Balance
      end
    end

    describe "POST create" do
      before do
        post :create, { good_id: @good.id, good_balance: valid_attributes }
      end

      subject { Good::Balance.first }

      its(:good_id)              { should == @good.id }
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
