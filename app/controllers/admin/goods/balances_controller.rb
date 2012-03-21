class Admin::Goods::BalancesController < Admin::ApplicationController
  before_filter :load_good

  def index
    @balances = @good.balances
  end

  def new
    @balance = @good.balances.build
  end

  def create
    @balance = @good.balances.build params[:good_balance]
    @balance.balance_type = "in"
    if @balance.save
      redirect_to admin_inventory_good_balances_url(@balance.good)
    else
      render "new"
    end
  end

  private

  def load_good
    @good = Good.where(id: params[:good_id]).within_company(current_user.company).first
    raise "This doesn't belong to you" if @good.nil?
  end
end
