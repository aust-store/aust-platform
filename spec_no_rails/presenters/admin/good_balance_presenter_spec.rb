class Presenter; end
module Admin; end

require "./app/presenters/admin/good_balance_presenter"

describe Admin::GoodBalancePresenter do
  def attributes
    { cost_per_unit: "10.0", total_cost: "14.14",
      created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @balance = stub attributes
    @presenter = Admin::GoodBalancePresenter.new @balance
  end

  describe ".cost_per_unit" do
    it "should return converted to R$" do
      @presenter.cost_per_unit.should == "R$ 10,00"
    end
  end

  describe ".total_cost" do
    it "should return converted to R$" do
      @presenter.total_cost.should == "R$ 14,14"
    end
  end

  describe ".cost_per_unit" do
    it "should return a float converted to R$" do
      @presenter.created_at.should == "14/04/2012"
    end
  end
end
