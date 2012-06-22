# TODO unit test
require 'spec_helper'

describe Admin::Goods::BalancesController do
  login_admin

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
    @balances = mock_model("Balance")
    @good = mock_model("Good")
    @balances.stub(:good).and_return(@good)
    @balances.stub(:balance_type=)

    Store::Currency.stub(:to_float).with("R$ 20.0").and_return(20.0)

    Good.stub_chain(:where, :within_company, :first).and_return(@good)
  end

  it "should raise if other company's id was given" do
    Good.stub_chain(:where, :within_company, :first).and_return(nil)
    expect { get :index, good_id: invalid_good.id }.to raise_error
  end

  describe "GET index" do
    before do
      @good.stub(:balances).and_return(@balances)
      Admin::GoodBalanceDecorator.stub(:decorate).and_return(@balances)
    end

    it "loads good's balances" do
      get :index, good_id: "1"
      assigns(:balances).should == @balances
    end
  end

  describe "GET new" do
    before do
      @good.stub_chain(:balances, :build).and_return(@balances)
    end

    it "builds a new balance" do
      get :new, good_id: "1"
      assigns(:balance).should == @balances
    end
  end

  describe "POST create" do
    before do
      @good.stub_chain(:balances, :build).with(sanitized_attributes).and_return(@balances)
      @balances.should_receive(:save).and_return(true)
    end

    it "should save balance" do
      post :create, { good_id: "1", good_balance: valid_attributes }
    end
  end

  describe "PUT update" do
    before do
      @good.stub_chain(:balances, :find).with("1").and_return(@balances)
      @balances.should_receive(:update_attributes).with(sanitized_attributes).and_return(true)
    end

    it "should save balance" do
      put :update, { id: 1, good_id: @good.id, good_balance: valid_attributes }
    end
  end
end
